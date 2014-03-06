module SusiesHelper

	def definedParams
		{
			login:            'login_x',
			maxStudent:       42,
			autologinURL:     'example.com',
			mailServer: 			'server.com',
			mailPort: 				1234,
			mailUname: 				'user@mail.com',
			mailPasswd: 			'passwd',
			mailTargets: 			%w[user1@mail.com user2@mail.com]
		}
	end

end
