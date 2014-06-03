# -*- coding: utf-8 -*-
require 'active_support/time'

class Susies
  # Susie login
  DEFAULT_LOGIN         = "clark_s"
  # Nombre max d'étudiants déjà inscrits
  DEFAULT_MAX_STUDENT   = 9
  # Heure de début minimale
  DEFAULT_MIN_HOUR      = 17
  # Autologin
  DEFAULT_AUTOLOGIN_URL = ''

  # Serveur mail (addr)
  DEFAULT_MAIL_SERVER   = ''
  # Serveur mail (port)
  DEFAULT_MAIL_PORT     = 0
  # Serveur mail (uname)
  DEFAULT_MAIL_UNAME    = ''
  # Serveur mail (pwd)
  DEFAULT_MAIL_PASSWD   = ''

  # Début de la 1ère semaine à checker
  DEFAULT_START_WEEK    = Date.today.beginning_of_week
  # Fin de la 1ère semaine à checker
  DEFAULT_END_WEEK      = Date.today.end_of_week

  # Susie JSON API
  SUSIES_URL            = "https://intra.epitech.eu/planning/587/events"
  # Susie Register link
  REGISTER_URL          = "https://intra.epitech.eu/planning/587"

  # Cookie File
  COOKIE_FILE           = "cookies.txt"
  # Buddies Cookie File
  BUDDIES_COOKIE_FILE   = "buddies_cookie_file.txt"

  # Encapsulation
  BASE_JSON             = "activities"
  # Register status to a Susie Class
  EVENT_REGISTERED_JSON = "event_registered"
  # Nb of people already registered to a Susie Class
  REGISTERED_JSON       = "registered"
  # Susie data
  MAKER_JSON            = "maker"
  # Susie login
  MAKER_LOGIN_JSON      = "login"
  # Susie Class ID
  ID_JSON               = "id"
  # Susie Class Start
  START_JSON            = "start"
  # Susie Class End
  END_JSON              = "end"
  # Susie Class Type
  TYPE_JSON             = "type"
  # Susie Class Title
  TITLE_JSON            = "title"
  # Susie Class Desc
  DESC_JSON             = "description"
end
