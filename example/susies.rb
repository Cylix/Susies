#!/usr/bin/ruby

require 'susies'

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
  autologinPath:     'https://intra.epitech.eu/my_autologin_url',
  buddiesAutologins: %w[/buddy_autologin_url],
}

# mailInfos: mailer configuration
mailInfos = {
  uname:  'mail@gmail.com',
  passwd: 'password',
  targets: %w[mylogin_x@epitech.eu buddy_login@epitech.eu]
}

Susies.new( autologins, whiteListfilters, blackListFilters, mailInfos ).check!
