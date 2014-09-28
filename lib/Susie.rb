# Dependencies
require 'time'

class Susie

  attr_accessor :is_registered, :nb_registered, :login, :id, :start, :end, :type, :title, :description, :url

  
  def initialize(susieJSON)
    self.id             = susieJSON['id']
    self.title          = susieJSON['title']
    self.type           = susieJSON['type']
    self.description    = susieJSON['description']
    self.login          = susieJSON['maker']['login']
    self.start          = Time.parse susieJSON['start']
    self.end            = Time.parse susieJSON['end']
    self.is_registered  = susieJSON['event_registered']
    self.nb_registered  = susieJSON['registered']
    self.url            = "#{ IntraRequestsManager::INTRA_BASE_URL }#{ IntraRequestsManager::REGISTER_SUSIE_PATH }/#{ self.id }"
  end


  def to_s
    <<-SUSIE
Login: #{ self.login }

Title: #{ self.title }
Type:  #{ self.type }

Start: #{ self.start }
End:   #{ self.end }

Places left: #{ 10 - self.nb_registered }

Registration URL: #{ self.url }

Description:
  #{ self.description }

    SUSIE
  end
  
end
