class UsersController < BaseController
	before_action :locate_user, only: [:show, :update, :notifications]

	def index
    @users = User.all
    respond_with(@users)
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

	def add
	end

	def add_mobile_number
		if current_user.update(mobile_number_params)
			MobileNumberService.new(current_user).send_verification_token
			redirect_to [:verify_number, current_user], notice: I18n.t('mobile_verification_code_sent')
		else
			redirect_to :back, alert: "Mobile verification code can not be sent"
		end
	end

	def generate_new_token
		MobileNumberService.new(current_user).send_verification_token
		redirect_to request.referrer, notice: "A new verification code has been sent to your phone"
	end

	def cancel_verification
		MobileNumberService.new(current_user).cancel_verification
		redirect_to [:mobile_number, current_user], notice: "Phone activation canceled"
	end

	def change
		if current_user.update(mobile_number_params)
			generate_and_send_verification_token
			redirect_to [:verify_number, current_user], notice: I18n.t('mobile_verification_code_sent')
		else
			render 'new', notice: t('add_new_mobile_number')
		end
	end

	def verify_number
	end

	def verify_mobile_number
		return redirect_to request.referrer, notice: t('blank_verification_code') if params[:user][:verification_code].blank?
		response = MobileNumberService.new(current_user).verify_number(params[:user][:verification_code])
		return redirect_to request.referrer, notice: "#{response}" unless response.eql?(true)
		redirect_to [:account, current_user], notice: t('correct_verification_code')
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