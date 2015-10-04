class BaseController < ApplicationController
	before_action :authenticate_user!
	before_action :ensure_twoway_authenticate
	

	def ensure_twoway_authenticate
		if current_user
			response = TwoWayAuthenticate.new(current_user).authenticate_twoway(params[:code])	
			unless response
				redirect_to :back, alert: "Sorry the code you gave is incorrect!"
			elsif response.present?
				redirect_to root_url, notice: "You have successfully logged in!"
			end			
		end
	end

end