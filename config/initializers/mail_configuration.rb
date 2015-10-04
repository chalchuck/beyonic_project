unless Rails.env == "test"
	ActionMailer::Base.delivery_method = :smtp
	ActionMailer::Base.perform_deliveries = true
	ActionMailer::Base.raise_delivery_errors = false

	ActionMailer::Base.smtp_settings = {
	  address: "smtp.mandrillapp.com",
	  port: 587,
	  domain: ENV.fetch('host', ''),
	  user_name: ENV.fetch('mandrill_username', ''),
	  password: ENV.fetch('mandrill_password', '')
	}
end