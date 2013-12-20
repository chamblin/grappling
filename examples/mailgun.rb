require 'grappling'
require 'mailgun'

redis_url "INSERT REDIS URL HERE"

name "Grappling Mailgun Example"

# this is a simple example to show the POWER of GRAPPLING
# GET YOUR OWN API KEYS, SUCKA

grapple do
	if is_resolve?
		m = Mailgun(:api_key => 'GET YOUR OWN',
		            :domain => 'INCLUDE THIS PART, TOO')

		message = {
			:subject => "#{user[:email]} just resolved #{description}",
			:from_name => "On call micromanager",
			:text => "",
			:to => "manager@company.com",
			:from => "manager@DOMAIN"
		}
		p m.messages.send_email message
	end
end