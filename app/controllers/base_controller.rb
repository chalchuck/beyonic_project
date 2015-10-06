class BaseController < ApplicationController
	before_action :authenticate_user!
	before_action :check_mobile_number
	before_action :ensure_twoway_authenticate#, except: [:check_mobile_number, :ensure_twoway_authenticate]
	

	def ensure_twoway_authenticate
		# binding.pry
		if current_user and current_user.authentication_code.present?

			# response = TwoWayAuthenticate.new(current_user).authenticate_twoway(params[:twoway_code])	
			redirect_to [:authenticate_twoway, current_user], notice: "Enter the verification code sent to your mobile number to authenticate"
			# return (redirect_to :back, alert: "Sorry the code you gave is incorrect!") unless response
			# redirect_to root_url, notice: "You have successfully logged in!"
		end
	end

	def check_mobile_number
		if !current_user.verified?
			redirect_to [:verify_number, current_user], notice: "wre;lghiodsjfg;lkj ljnjk"
		end
	end

end