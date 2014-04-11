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
	# @login        Asked Susie Login                      Default: clark_s
	# @maxStudent   Maximum already registered students    Default: 9
	#
	# @autologinURL Intranet Autologin URL                 No default
	# @mailServer   Mail Server                            No default
	# @mailPort     Mail Port                              No default
	# @mailUname    Mail UserName                          No default
	# @mailPasswd   Mail Password                          No default
	# @mailTargets  People to inform by mail about sub.    Default: @mailUname
	#
	# @buddiesAuto. Buddies autologins 										 No default
	#
	# @startWeek    Beginning of week                      Default: beginning of current week
	# @endWeek      End of week                            Default: end of current week
	##
	def initialize(data={})
		@login        			= data[:login]       				|| [DEFAULT_LOGIN]
		@maxStudent   			= data[:maxStudent]  				|| DEFAULT_MAX_STUDENT
		@minHour						= data[:minHour]						|| DEFAULT_MIN_HOUR
		@autologinURL 			= data[:autologinURL] 			|| DEFAULT_AUTOLOGIN_URL

		@mailServer   			= data[:mailServer]					|| DEFAULT_MAIL_SERVER
		@mailPort     			= data[:mailPort]						|| DEFAULT_MAIL_PORT
		@mailUname    			= data[:mailUname]					|| DEFAULT_MAIL_UNAME
		@mailPasswd   			= data[:mailPasswd]  				|| DEFAULT_MAIL_PASSWD
		@mailTargets  			= data[:mailTargets] 				|| [@mailUname]

		@buddiesAutologins 	= data[:buddiesAutologins] 	|| []

		@startWeek    			= DEFAULT_START_WEEK
		@endWeek      			= DEFAULT_END_WEEK
	end


	##
	# Check!
	#
	# Iterate throw weeks, until there is no Susie in a week.
	# For each week, check if the current user is already registered to a Susie Class.
	# If user has not already been registered to a Susie Class, try to find an available Susie following criterias (maxStudent and Susie Login).
	# If a Susie class is found, try to register to this Susie Class and send a mail to user's friends.
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
	# Try to find and register to a Susie Class.
	# Send Mail to user's friends in case of success. 
	##
	def findSusie(susiesData)
		log "Trying to register susie class with #{ @login } for week: #{ formatDate @startWeek } #{ formatDate @endWeek }."

		susiesData[BASE_JSON].each do |susie|
			if matchCriterias? susie
				registerSusie 	susie, COOKIE_FILE
				registerBuddies	susie
				informBuddies 	susie
				
				return true
			end
		end
		
		log "No susie class found following criterias."
		return false
	end


	##
	# formatDate
	#
	# Take Date Object as parameter
	# Return formated Date (YYY-MM-DD)
	##
	def formatDate(date)
		date.strftime '%Y-%m-%d'
	end


	##
	# formatTime
	#
	# Take Time Object as parameter
	# Return formated Time (HH:MM YYY-MM-DD)
	##
	def formatTime(time)
		time.strftime '%H:%M %Y-%m-%d'
	end


	##
	# getSusiesData
	#
	# Return Susie Classes JSON Data
	#
	def getSusiesData
		JSON.parse  `curl -s -L -b #{ COOKIE_FILE } '#{ SUSIES_URL }?start=#{ formatDate @startWeek }&end=#{ formatDate @endWeek }&format=json'`
	end


	##
	# getRegisterMail
	#
	# Generate mail which will be send to user's friends.
	##
	def getRegisterMail(susie)
		<<-MESSAGE
Hey,

I've just registered to a susie class with #{ susie[MAKER_JSON][MAKER_LOGIN_JSON] }.

Title:        #{ susie[TITLE_JSON] }
Type:         #{ susie[TYPE_JSON] }

Description:
	#{ susie[DESC_JSON] }

Start:        #{ susie[START_JSON] }.
End:          #{ susie[END_JSON] }.
Place left:   #{ 9 - susie[REGISTERED_JSON] }.

Register here: #{ REGISTER_URL }/#{ susie[ID_JSON] }.

		MESSAGE
	end


	##
	# informBuddies
	#
	# send mail to user's friends
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
	#
	# Write log info
	##
	def log(message)
		puts "[#{ formatTime Time.now }]> #{ message }"
	end


	##
	# matchCriterias
	#
	# Does Susie match defined criterias?
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
	# Go to next week
	##
	def nextWeek!
		@startWeek += 1.week
		@endWeek   += 1.week
	end


	##
	# noSusie?
	#
	# Check if there are SusieClasses in the given JSON data
	##
	def noSusie?(susiesData)
		!susiesData[BASE_JSON] or susiesData[BASE_JSON].length == 0
	end


	##
	# registerBuddies
	#
	# register buddies with given autologins
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
	# register to given SusieClass
	##
	def registerSusie(susie, cookie_file)
		`curl -s -b #{ cookie_file } -L -X POST #{ REGISTER_URL }/#{ susie[ID_JSON] }/subscribe?format=json`
		log "Succesfully registered to susie class."
	end


	##
	# registeredThisWeek?
	#
	# Determine if user is already registered to a Susie Class during the given week.
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
	# send mail from user to a buddy.
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
	# Log on the intra and save user's cookie in COOKIE_FILE
	##
	def setAuthCookie(cookie_file, autologin)
		`curl -s -L -c #{ cookie_file } #{ autologin }`
	end

end
