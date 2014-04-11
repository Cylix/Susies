# Susies

## Description

Susies est une gem destinée au étudiant d'Epitech.

Elle permet de trouver simplement une susie en fonctions de quelques critères.


## Installation

Soit par ligne de commande: `gem install susies`

Soit via un `Gemfile`: `gem 'susies'` et `bundle install`


## Utilisation

L'utilisation est assez simple:

```
require 'susies'

data = {
	login:              %w[login_x],
	maxStudent:         6,
	autologinURL:       'https://intra.epitech.eu/my_autologin_url',
	mailServer:         'smtp.gmail.com',
	mailPort:           587,
	mailUname:          'mail@gmail.com',
	mailPasswd:         'password',
	mailTargets:        %w[mylogin_x@epitech.eu buddy_login@epitech.eu],
	buddiesAutologins:  %w[https://intra.epitech.eu/buddy_autologin_url]
}

Susies.new( data ).check!
```

La gem se connectera alors à l'intra pour vérifier l'existence d'une susie correspond à vos critères durant une semaine où vous n'avez pas encore de susie.

Si elle trouve une susie, elle vous inscrira à la susie, inscrira vos amis et préviendra tout le monde par mail.


### login

Les logins des susies recherchées.

Type: Array

Default: ['clark_s']


### maxStudent

Nombre d'étudiants déjà inscrit à la susie class (0: personne d'inscrit, 10: plus de places)

Type: int

Default: 9


### minHour

Heure minimum du début de la susie class.

Type: Int

Default: 17


### mailServer

Serveur Mail (pour l'envoi de mail). cf `example/susies.rb` pour un exemple de configuration basé sur gmail.

Type: String

Default: ''


### mailPort

Port du serveur mail. cf `example/susies.rb` pour un exemple de configuration basé sur gmail.

Type: Int

Default: 0


### mailUname

Nom d'utilisateur pour se connecter au serveur mail. cf `example/susies.rb` pour un exemple de configuration basé sur gmail.

Type: String

Default: ''


### mailPasswd

Mot de passe pour se connecter au serveur mail. cf `example/susies.rb` pour un exemple de configuration basé sur gmail.

Type: String

Default: ''


### mailTargets

Emails des personnes devant être alertés lorsqu'une susie a été trouvée.

Type: Array

Default: [mailUname]


### buddiesAutologins

Autologins des personnes devant être inscrites à la susie class (en plus de vous).

Type: Array

Default: []


## Cron Task

Une bonne utilisation de cette gem serait de l'utiliser via une tache cron qui lancera le script à intervalle régulier.

Par exemple, il est intéressant de faire une tache s'exécutant toutes les 5 minutes:

```
*/5 * * * * GEM_HOME=/path/to/gem/home /path/to/script.rb 1>> /path/to/log 2>> /path/to/errors.log
```


## Améliorations Possibles

1. Dictionnaire de mots clés
2. Planning horaire par jour
3. Blacklist
4. Ajouts de critères?


## Doc

Une doc peut être générée grâce à la commande `sdoc`.
La gem `sdoc` est bien évidemment nécessaire... (`gem install sdoc`)
You can generate documentation by executing: `sdoc`


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
