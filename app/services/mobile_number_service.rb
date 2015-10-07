class MobileNumberService
	
	attr_accessor :user

	def initialize(user)
		@user = user
	end

	def format(number)
		number.gsub(/[^0-9]/i, '')
	end

	def prepend_prefix(number)
		format(number).gsub(/^0|^7/,'+254')
	end

	def normalize(number)
		number.gsub(/^254/, '0')
	end

	def check_number?(mobile_token)
		user.mobile_verification_code.to_i == mobile_token.to_i if mobile_token
	end

	def cancel_verification
		user.update(mobile_verification_code: nil, mobile_number: "")
	end

	def confirmed?
		user.verified_at.present? && !user.mobile_verification_code.present?
	end

	def verify_number(mobile_token)
		return I18n.t('mobile_token_is_blank') if mobile_token.blank?
		return I18n.t('invalid_mobile_token') unless check_number?(mobile_token)

		user.update(mobile_verification_code: nil, verified_at: Time.now.utc)
	end

	def send_mobile_verification_code
		verify_code = verification_token
		user.update(mobile_verification_code: verify_code)
		message = %{Hello #{user.try(:name)}, Your mobile number verification code is, #{verify_code}}
		AfricasTalking::Message.new(ENV['SMS_API_USERNAME'], ENV['SMS_API_KEY']).deliver(user.try(:mobile_number), message)
	end

	def verification_token		
		loop do
			range = (0..9).to_a
			token = (0..5).map {|opt| rand(range.length)}.join
			break token unless User.where('lower(mobile_verification_code) = :qs', qs: token.downcase).present?
		end		
	end

end