# Susies

## Description

Susies est une gem destinée aux étudiants d'Epitech.

Elle permet de trouver simplement une susie en fonction de quelques critères.


## Installation

Soit par ligne de commande: `gem install susies`

Soit via un `Gemfile`: `gem 'susies'` et `bundle install`


## Utilisation

L'utilisation est assez simple:

```

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
```

La gem se connectera alors à l'intra pour vérifier l'existence d'une susie correspondant à vos critères, durant une semaine où vous n'avez pas encore de susie.

Si elle trouve une susie, elle vous y inscrira, inscrira vos amis et préviendra tout le monde par mail.

## Filters

A utiliser si vous souhaitez filtrer les susies qui vous intéressent.

Les whiteListFilters sont les critères que les susies doivent avoir, à l'inverse des blackListFilters.

Laissez `nil` si vous ne voullez pas de filtres.

### login

* Les logins des susies recherchées.
* Type: Array
* Default: nil


### maxStudent

* Nombre d'étudiants déjà inscrit à la susie class (0: personne d'inscrit, 10: plus de places)
* Type: int
* Default: nil


### minHour

* Heure minimum du début de la susie class.
* Type: Int
* Default: nil


### maxHour

* Heure maximum du début de la susie class.
* Type: Int
* Default: nil


### title

* KeyWord que le titre de la susie doit contenir.
* Type: String
* Default: nil


### type

* Type de la susie
* Type: String
* Default: nil


## MailInfos

A utiliser si vous souhaitez être alerté en cas d'inscription par le script. Fonctionne avec une adresse GMail.

Laissez `nil` si vous ne voullez pas envoyer de mails.

### uname

* Nom d'utilisateur pour se connecter au serveur mail. cf `example/susies.rb` pour un exemple de configuration basé sur gmail.
* Type: String
* Default: nil


### passwd

* Mot de passe pour se connecter au serveur mail. cf `example/susies.rb` pour un exemple de configuration basé sur gmail.
* Type: String
* Default: nil


### targets

* Emails des personnes devant être alertés lorsqu'une susie a été trouvée.
* Type: Array
* Default: nil


## Autologins

### autologinPath

* Votre autologin. Il s'agit du path et non de l'URL complète. Ce paramètre est OBLIGATOIRE!
* Type String
* Default: nil

### buddiesAutologins

* Autologins des personnes devant être inscrites à la susie class (en plus de vous). Il s'agit du path et non de l'URL complète.
* Type: Array
* Default: []


## Cron Task

Une bonne utilisation de cette gem serait de l'utiliser via une tache cron qui lancera le script à intervalle régulier.

Par exemple, il est intéressant de faire une tache s'exécutant toutes les 5 minutes:

```
*/5 * * * * GEM_HOME=/path/to/gem/home /path/to/script.rb 1>> /path/to/log 2>> /path/to/errors.log
```


## Améliorations Possibles

1. Gestion des jours
2. Planning horaire par jour


## Contribuer

1. Fork
2. Créer votre branche (`git checkout -b my-branch`)
3. Commit les nouvelles fonctionnalités (`git commit -am 'New features'`)
4. Push (`git push origin my-branch`)
5. Faire une `Pull request`


## License

[MIT License](MIT_LICENSE.txt)


## Author

[Simon Ninon](http://sninon.fr) aka [ninon_s](http://intra.epitech.eu/user/ninon_s) aka [Cylix](http://github.com/Cylix)
