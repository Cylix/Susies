# Dependencies
require 'active_support/time'
require 'net/smtp'
require './Susie.rb'
require './IntraRequestsManager.rb'

class Susies

  def initialize(autologins={}, filters=nil, mailInfos=nil)
    @filters   = filters]
    @mailInfos = mailInfos

    @autologinPath     = autologins[:autologinPath]
    @buddiesAutologins = autologins[:buddiesAutologins] || []
    @requestsManager   = IntraRequestsManager.new
  end

  
  def check!
    @requestsManager.authenticate! @autologinPath
    
    startDate = Date.today.beginning_of_week
    endDate   = Date.today.end_of_week

    loop do
      susies = @requestsManager.getSusies startDate, endDate
      
      break if susies.empty?

      findSusie susies unless registeredThisWeek? susies
      
      startDate += 1.week
      endDate   += 1.week
    end
  end

  
  private

  
  def findSusie(susies)
    susies.each do |susie|
      if matchCriterias? susie
	registerSusie  susie
        informEveryone susie
        break
      end
    end
  end


  def formatTime(time)
    time.strftime '%H:%M %Y-%m-%d'
  end

  def getRegisterMail(susie)
    <<-MESSAGE
Hey,

I've just registered to a susie class.

#{ susie.to_s }
    MESSAGE
  end


  def informEveryone(susie)
    if @mailInfos && @mailInfos[:targets]
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      
      smtp.start('gmail.com', @mailInfos[:email], @mailInfos[:passwd], :plain) do |smtp|
        smtp.send_message getRegisterMail(susie), @mailInfos[:email], @mailInfos[:targets]
      end
    end
  end
  
  def matchCriterias?(susie)
    return true unless @filters

    good_min_hour    = @filters[:minHour].nil? || susie.start >= @filters[:minHour]
    good_max_hour    = @filters[:maxHour].nil? || susie.end >= @filters[:maxHour]
    good_nb_students = @filters[:nb_registered].nil? || susie.nb_registered <= @filters[:nb_registered]
    good_login       = @filters[:logins].nil?
    good_type        = @filters[:type].nil? || susie.type == @filters[:type]
    good_title       = @filters[:title].nil? || susie.title.include? @filters[:title]

    if @filters[:logins]
      @logins.each do |login|
        good_login = true if susie.login == login
      end
    end

    return good_min_hour && good_max_hour && good_login && good_nb_students && good_type && good_title
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
    susies.each do |susie|
      return true if susie.is_registered
    end
    
    false
  end

  
end
