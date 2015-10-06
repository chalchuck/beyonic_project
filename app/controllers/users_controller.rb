class UsersController < BaseController
	skip_before_action :check_mobile_number, only: [:verify_number, :verify_mobile_number, :generate_new_token]
  skip_before_action :ensure_twoway_authenticate, only: [:authenticate_twoway, :verify_number, :verify_mobile_number, :generate_new_token]
	before_action :locate_user, only: [:show, :update, :notifications]

	def index
    @users = User.all
    # respond_with(@users)
  end

  def show
  end

  def edit
  end

  def notifications
  end

  def update
    @user.update(user_params)
    respond_with(@user)
  end

  def verify_number
    @title = "Hi #{current_user}, Confirm your Mobile Number."
    current_user.mobile_verification_code = ""
  end

  def authenticate_twoway
    if request.method == "GET"
      
    elsif request.method == "POST"
      return (redirect_to :back, alert: "The code can not be blank") if params[:user][:twoway_code].blank?
      response = TwoWayAuthenticate.new(current_user).authenticate(params[:user][:twoway_code])
      return (redirect_to :back, alert: "Sorry the code you gave is incorrect!") unless response
      redirect_to root_url, notice: "You have successfully logged in!"
    end
  end

	def generate_new_token
		MobileNumberService.new(current_user).send_mobile_verification_code
		redirect_to request.referrer, notice: "A new verification code has been sent to your phone"
	end

	def verify_number
	end

	def verify_mobile_number
		if request.method == "GET"
			current_user.mobile_verification_code = ""
		elsif request.method == "POST"
			return redirect_to request.referrer, notice: t('blank_verification_code') if params[:user][:verification_code].blank?
			response = MobileNumberService.new(current_user).verify_number(params[:user][:verification_code])
			return redirect_to request.referrer, notice: "#{response}" unless response.eql?(true)
			redirect_to root_url, notice: t('correct_verification_code')	
		end
	end

private

  def user_params
    params.require(:user).permit(:email, :mobile_number, :full_name, :verification_code, :username)
  end

  def mobile_number_params
		params.require(:user).permit(:mobile_number)
	end

	def locate_user
		@user = User.find(params[:id]) if params[:id]
		rescue ActiveRecord::RecordNotFound => e
		redirect_to root_url, alert: "#{e.message}"
	end

end