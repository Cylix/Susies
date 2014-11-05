# Dependencies
require 'active_support/time'
require 'net/smtp'
require 'susies/Susie'
require 'susies/IntraRequestsManager'

class Susies

  def initialize(autologins={}, whiteListFilters=nil, blackListFilters=nil, mailInfos=nil)
    @whiteListFilters   = whiteListFilters
    @blackListFilters   = blackListFilters
    @mailInfos          = mailInfos

    @autologinPath     = autologins[:autologinPath]
    @buddiesAutologins = autologins[:buddiesAutologins] || []
    @requestsManager   = IntraRequestsManager.new
  end

  
  def check!
    @requestsManager.authenticate! @autologinPath
    
    startDate = Date.today.beginning_of_week
    endDate   = Date.today.end_of_week

    loop do
      log "Check for week #{ formatDate startDate } - #{ formatDate endDate }"
      susies = @requestsManager.getSusies startDate, endDate
      
      break if susies.empty?

      findSusie susies unless registeredThisWeek? susies
      
      startDate += 1.week
      endDate   += 1.week
    end
  end

  
  private

  def log(message)
    puts "[#{ formatTime Time.now }]> #{ message }"
  end

  
  def findSusie(susies)
    log "Not already registrated: seeking susies"
    susies.each do |susie|
      log "Checking criterias of: #{ susie.to_s }"
      if !matchCriterias?(susie, @blackListFilters) && matchCriterias?(susie, @whiteListFilters)
        log "Find susie matching criterias: #{ susie.to_s }"
        log "Registering to susie"
	registerSusie  susie
        log "Sending mails"
        informEveryone susie
        log "done"
        break
      end
    end
  end


  def formatDate(time)
    time.strftime '%d-%m-%Y'
  end

  def formatTime(time)
    time.strftime '%H:%M %d-%m-%Y'
  end

  def getRegisterMail(susie)
    <<-MESSAGE
Hey,

I've just registered to a susie class.

#{ susie.to_text }
    MESSAGE
  end


  def informEveryone(susie)
    if @mailInfos && @mailInfos[:targets]
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      
      smtp.start('gmail.com', @mailInfos[:uname], @mailInfos[:passwd], :plain) do |smtp|
        smtp.send_message getRegisterMail(susie), @mailInfos[:email], @mailInfos[:targets]
      end
    end
  end

  
  def matchCriterias?(susie, filters)
    return true unless filters

    min_hour    = filters[:minHour].nil? || (susie.start.hour >= filters[:minHour])
    max_hour    = filters[:maxHour].nil? || (susie.end.hour >= filters[:maxHour])
    nb_students = filters[:nb_registered].nil? || (susie.nb_registered <= filters[:nb_registered])
    login       = filters[:logins].nil? || (filters[:logins].include?(susie.login))
    type        = filters[:type].nil? || (susie.type == filters[:type])
    title       = filters[:title].nil? || (susie.title.include?(filters[:title]))

    min_hour && max_hour && login && nb_students && type && title
  end

  
  def registerSusie(susie)
    @requestsManager.registerSusie susie

    if @buddiesAutologins
      @buddiesAutologins.each do |autologin|
        buddiesRequestsManager = IntraRequestsManager.new
        buddiesRequestsManager.authenticate! autologin
        buddiesRequestsManager.registerSusie susie
      end
    end
  end
  

  def registeredThisWeek?(susies)
    susies.each { |susie| return true if susie.is_registered }
    false
  end

  
end
