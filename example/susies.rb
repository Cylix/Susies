#!/usr/bin/ruby

require 'susies'

# whiteListFilters: susies MUST match these filters
whiteListFilters = {
  logins:        %w[login_x],
  nb_registered: 6,
  minTime:       "8:10",
  maxTime:       "17:42"
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
