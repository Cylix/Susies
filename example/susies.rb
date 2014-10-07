#!/usr/bin/ruby

require 'Susies'

# whiteListFilters: susies MUST match these filters
whiteListFilters = {
  login:      %w[login_x],
  maxStudent: 6,
  minHour:    8,
  maxHour:    17
}

# blackListFilters: susies MUST NOT match these filters
blackListFilters = {
  type: 'reading',
  title: 'zola'
}

# autologin: intranet authentication
autologins = {
  autologinPath:     '/autologin_path',
  buddiesAutologins: %w[/buddy_autologin_path],
}

# mailInfos: mailer configuration
mailInfos = {
  uname:  'mail@gmail.com',
  passwd: 'password',
  targets: %w[mylogin_x@epitech.eu buddy_login@epitech.eu]
}

Susies.new( autologins, whiteListFilters, blackListFilters, mailInfos ).check!
