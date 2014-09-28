# Dependencies
require './Susie.rb'
require 'net/http'
require 'json'

class IntraRequestsManager

  INTRA_BASE_URL        = 'intra.epitech.eu'
  LIST_SUSIES_PATH      = '/planning/587/events'
  REGISTER_SUSIE_PATH   = '/planning/587'

  
  def initialize
    @http = Net::HTTP.new INTRA_BASE_URL, 443
    @http.use_ssl = true
  end

  
  def authenticate!(autologinPath)
    response = @http.get autologinPath
    
    response_cookies = response.get_fields 'set-cookie'
    cookies_array = response_cookies.collect { |cookie| cookie.split('; ').first }

    @cookies = cookies_array.join('; ')
  end

  
  def getSusies(startDate, endDate)
    path = "#{ LIST_SUSIES_PATH }?start=#{ formatDate startDate }&end=#{ formatDate endDate }&format=json"
    response = @http.get path, { 'Cookie' => @cookies }

    susiesJSON = JSON.parse response.body

    unless susiesJSON['activities'].nil?
      susiesJSON['activities'].collect { |susieJSON| Susie.new susieJSON }
    else
      []
    end
  end

  
  def registerSusie(susie)
    path = "#{ REGISTER_SUSIE_PATH }/#{ susie.id }/subscribe?format=json"
    response = @http.post path, { 'Cookie' => @cookies }

    susie.nb_registered -= 1    
    susie
  end

  
  private

  
  def formatDate(date)
    date.strftime '%Y-%m-%d'
  end

end
