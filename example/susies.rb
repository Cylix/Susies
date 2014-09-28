#!/usr/bin/ruby

require 'susies'

filters = {
  login:      %w[login_x],
  maxStudent: 6,
  minHour:    8,
  maxHour:    17
}

autologins = {
  autologinPath:     'https://intra.epitech.eu/my_autologin_url',
  buddiesAutologins: %w[/buddy_autologin_url],
}

mailInfos = {
  uname:  'mail@gmail.com',
  passwd: 'password',
  targets: %w[mylogin_x@epitech.eu buddy_login@epitech.eu]
}

Susies.new( autologins, filters, mailInfos ).check!
