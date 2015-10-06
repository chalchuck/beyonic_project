unless Rails.env.eql?("test")

	ActionMailer::Base.delivery_method       = :smtp
	ActionMailer::Base.perform_deliveries    = true
	ActionMailer::Base.raise_delivery_errors = false

	ActionMailer::Base.smtp_settings = {
		address:  "smtp.mandrillapp.com",
		port:      587,
		domain:    ENV['HOST'],	  
	  user_name: ENV['MANDRILL_USERNAME'],
	  password:  ENV['MANDRILL_PASSWORD']
	}

end