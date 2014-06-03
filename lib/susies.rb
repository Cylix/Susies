# -*- coding: utf-8 -*-
# Constants
require 'constants.rb'
# Dependencies
require 'active_support/time'
require 'net/smtp'
require 'json'

##
# Susies Class
##
class Susies

  ##
  # Initialize
  #
  # @login        Susie recherchée                      Par défaut: clark_s
  # @maxStudent   Nb max d'étudiants déjà inscrits      Par défaut: 9
  #
  # @autologinURL Intranet Autologin URL                Pas de val par défaut
  # @buddiesAuto. Autologin des amis à inscrire         Pas de val par défaut
  #
  # @mailServer   Serveur mail (addr)                   Pas de val par défaut
  # @mailPort     Serveur mail (port)                   Pas de val par défaut
  # @mailUname    Serveur mail (uname)                  Pas de val par défaut
  # @mailPasswd   Serveur mail (pwd)                    Pas de val par défaut
  # @mailTargets  Personnes à prévenir                  Par défaut: @mailUname
  #
  # @startWeek    Début de la 1ère semaine à checker    Par défaut: début de la semaine courante
  # @endWeek      Fin de la 1ère semaine à checker      Par défaut: fin de la semaine courante
  ##
  def initialize(data={})
    @login              = data[:login]			|| [DEFAULT_LOGIN]
    @maxStudent         = data[:maxStudent]		|| DEFAULT_MAX_STUDENT
    @minHour            = data[:minHour]		|| DEFAULT_MIN_HOUR
    @autologinURL	= data[:autologinURL]		|| DEFAULT_AUTOLOGIN_URL
    @buddiesAutologins	= data[:buddiesAutologins]	|| []
    
    @mailServer		= data[:mailServer]		|| DEFAULT_MAIL_SERVER
    @mailPort		= data[:mailPort]		|| DEFAULT_MAIL_PORT
    @mailUname		= data[:mailUname]		|| DEFAULT_MAIL_UNAME
    @mailPasswd		= data[:mailPasswd]		|| DEFAULT_MAIL_PASSWD
    @mailTargets	= data[:mailTargets]		|| [@mailUname]
        
    @startWeek		= DEFAULT_START_WEEK
    @endWeek		= DEFAULT_END_WEEK
  end
  

  ##
  # Check!
  #
  # Boucle de semaine en semaine, jusqu'à tomber sur une semaine sans susies
  # Pour chaque semaine, vérifie si l'utilisateur n'est pas déjà inscrit à une susie
  # Si l'utilisateur n'est pas encore inscrit, cherche une susie correspondant aux critères
  # Si une susie est trouvée, tente d'inscrire l'utilisateur et ses amis et prévient tout le monde par mail
  ##
  def check!
    log 'Start Checking'
    setAuthCookie COOKIE_FILE, @autologinURL
    
    while true
      susiesData = getSusiesData
      
      break if noSusie? susiesData
      
      findSusie susiesData unless registeredThisWeek? susiesData
      
      nextWeek!
    end
    
    log 'End Checking'
  end
  
  
  private

  
  ##
  # findSusie
  #
  # Essaye de trouver une susie et de s'y inscrire
  # Préviens les inscrits par mail en cas de succès
  ##
  def findSusie(susiesData)
    log "Trying to register class with #{ @login } for week: #{ formatDate @startWeek } #{ formatDate @endWeek }."
    
    susiesData[BASE_JSON].each do |susie|
      if matchCriterias? susie
        registerSusie	susie, COOKIE_FILE
        registerBuddies	susie
        informBuddies	susie
        
        return true
      end
    end
    
    log "No susie class found following criterias."
    return false
  end
  
  
  ##
  # formatDate
  #
  # Prends un Date Object en paramètre
  # Retourne une string contenant la date formatée (YYYY-MM-DD)
  ##
  def formatDate(date)
    date.strftime '%Y-%m-%d'
  end

  
  ##
  # formatTime
  #
  # Prends un Time Object en paramètre
  # Retourne une string contenant le temps formaté (HH-MM YYYY-MM-DD)
  ##
  def formatTime(time)
    time.strftime '%H:%M %Y-%m-%d'
  end


  ##
  # getSusiesData
  #
  # Récupère les données JSON des susies de la semaine en cours de check
  ##
  def getSusiesData
    JSON.parse `curl -s -L -b #{ COOKIE_FILE } '#{ SUSIES_URL }?start=#{ formatDate @startWeek }&end=#{ formatDate @endWeek }&format=json'`
  end
  
  
  ##
  # getRegisterMail
  #
  # Generate mail which will be send to user's friends.
  ##
  def getRegisterMail(susie)
    <<-MESSAGE
Salut,

Je viens de m'inscrire à une Susie avec #{ susie[MAKER_JSON][MAKER_LOGIN_JSON] }.

Titre:  #{ susie[TITLE_JSON] }
Type:   #{ susie[TYPE_JSON] }

Début:  #{ susie[START_JSON] }.
Fin:    #{ susie[END_JSON] }.

Description:
        #{ susie[DESC_JSON] }

Lien de la susie: #{ REGISTER_URL }/#{ susie[ID_JSON] }.
MESSAGE
  end


  ##
  # informBuddies
  #
  # Envoie un mail à la mailing list
  ##
  def informBuddies(susie)
    message = getRegisterMail susie
    
    for email in @mailTargets
      log "Send mail to #{ email }"
      sendMail email, message
    end
  end


  ##
  # log
  ##
  def log(message)
    puts "[#{ formatTime Time.now }]> #{ message }"
  end
  

  ##
  # matchCriterias
  #
  # Vérifie si la susie correspond aux critères voulus
  ##
  def matchCriterias?(susie)
    @login.each do |login|
      return true if susie[MAKER_JSON][MAKER_LOGIN_JSON] == login and susie[REGISTERED_JSON] <= @maxStudent and Time.parse(susie[START_JSON]).hour >= @minHour
    end
    false
  end


  ##
  # nextWeek!
  #
  # Itère à la semaine suivante
  ##
  def nextWeek!
    @startWeek += 1.week
    @endWeek   += 1.week
  end


  ##
  # noSusie?
  #
  # Vérifie le nombre de susies dans les données JSON retournées par l'API
  ##
  def noSusie?(susiesData)
    !susiesData[BASE_JSON] or susiesData[BASE_JSON].length == 0
  end
  

  ##
  # registerBuddies
  #
  # Inscrit les amis grâce à leurs autologins
  ##
  def registerBuddies(susie)
    @buddiesAutologins.each do |autologin|
      setAuthCookie BUDDIES_COOKIE_FILE, autologin
      registerSusie susie, BUDDIES_COOKIE_FILE
    end
  end


  ##
  # registerSusie
  #
  # Inscription à la susie
  ##
  def registerSusie(susie, cookie_file)
    `curl -s -b #{ cookie_file } -L -X POST #{ REGISTER_URL }/#{ susie[ID_JSON] }/subscribe?format=json`
    log "Succesfully registered to susie class."
  end
  

  ##
  # registeredThisWeek?
  #
  # Vérifie si l'utilisateur n'est pas déjà inscrit à une susie dans la semaine
  ##
  def registeredThisWeek?(weekSusies)
    weekSusies[BASE_JSON].each do |susie|
      if susie[EVENT_REGISTERED_JSON]
        log "Already registered to a susie class with #{ susie[MAKER_JSON][MAKER_LOGIN_JSON] } for week: #{ formatDate @startWeek } #{ formatDate @endWeek }."
        return true
      end
    end
    
    log "Not registered to a susie class for week: #{ formatDate @startWeek } #{ formatDate @endWeek }."
    return false
  end
  

  ##
  # sendMail
  #
  # Envoie un mail
  ##
  def sendMail(email, message)
    smtp = Net::SMTP.new @mailServer, @mailPort
    smtp.enable_starttls_auto
    smtp.start @mailServer, @mailUname, @mailPasswd, :plain
    smtp.send_message message, @mailUname, email
  end

  
  ##
  # setAuthCookie
  #
  # Se log à l'intra via l'autologin et sauvegarde le cookie
  ##
  def setAuthCookie(cookie_file, autologin)
    `curl -s -L -c #{ cookie_file } #{ autologin }`
  end
  
end
