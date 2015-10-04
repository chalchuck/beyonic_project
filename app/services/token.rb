class Token
	
	def generate_token(chars=5, resource)
		loop do
			token = SecureRandom.base64(chars).gsub(/[+=\/]*/,"").upcase
			break token unless resource.classify.constantize.where("lower(authentication_code) = :qs OR lower(mobile_verification_code) = :qs", qs: token.downcase).present?
	  end
	end

end