#!/usr/bin/ruby

require 'susies'

data = {
	login:        			%w[login_x],
	maxStudent:   			6,
	autologinURL: 			'https://intra.epitech.eu/my_autologin_url',
	mailServer: 				'smtp.gmail.com',
	mailPort: 					587,
	mailUname: 					'mail@gmail.com',
	mailPasswd: 				'password',
	mailTargets: 				%w[mylogin_x@epitech.eu buddy_login@epitech.eu],
	buddiesAutologins: 	%w[https://intra.epitech.eu/buddy_autologin_url]
}

Susies.new( data ).check!
