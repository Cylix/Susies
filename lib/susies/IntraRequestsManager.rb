# Dependencies
require 'susies/Susie'
require 'net/http'
require 'json'

class IntraRequestsManager
  
  def initialize
    @http = Net::HTTP.new 'intra.epitech.eu', 443
    @http.use_ssl = true
    @planningID = 0
  end

  
  def authenticate!(autologinPath)
    response = @http.get autologinPath
    
    response_cookies = response.get_fields 'set-cookie'
    cookies_array = response_cookies.collect { |cookie| cookie.split('; ').first }
    @cookies = cookies_array.join('; ')

    fetchPlanningID!
  end

  def fetchPlanningID!
    path = "/planning/all-schedules/?format=json"
    response = @http.get path, { 'Cookie' => @cookies }

    planningsJSON = JSON.parse response.body

    unless planningsJSON.nil?
      planningsJSON.each do |planning|
        if planning['type'] == 'susie'
          @planningID = planning['id']
          break
        end
      end
    end
  end

  
  def getSusies(startDate, endDate)
    path = "/planning/#{ @planningID }/events?start=#{ formatDate startDate }&end=#{ formatDate endDate }&format=json"
    response = @http.get path, { 'Cookie' => @cookies }

    susiesJSON = JSON.parse response.body

    unless susiesJSON.nil?
      susiesJSON.collect { |susieJSON| Susie.new susieJSON, "https://intra.epitech.eu/planning/#{ @planningID }/#{ susieJSON['id'] }" }
    else
      []
    end
  end

  
  def registerSusie(susie)
    path = "/planning/#{ @planningID }/#{ susie.id }/subscribe?format=json&registercalendar"
    response = @http.post path, '', { 'Cookie' => @cookies }

    susie.nb_registered += 1
    susie
  end

  
  private

  
  def formatDate(date)
    date.strftime '%Y-%m-%d'
  end

end
