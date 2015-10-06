class TwoWayAuthenticate

	attr_accessor :resource

	def initialize(resource)
		@resource = resource
	end

	def authenticate(code)
		correct_code?(code) ? resource.update(authentication_code: nil) :false
	end

	def correct_code?(code)
		# resource.authentication_code.eql?(code)
		User.where(authentication_code: code).present?
	end

	def twowaycode
		loop do
			token = SecureRandom.base64(5).gsub(/[+=\/]*/,"").upcase
			break token unless User.where("lower(authentication_code) = :query_string", query_string: token.downcase).present?
	  end
	end

	def send_twowaycode
		verify_code = twowaycode
		resource.update(authentication_code: verify_code)
		message = %{ Hi #{resource.try(:name)}, enter this code to login to your account}
		p message
		# AfricasTalking::Message.new(ENV.fetch('username'), ENV.fetch('pass')).deliver(recipient: resource.try(:mobile_number), message: message)		
	end

end