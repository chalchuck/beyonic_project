module DevisePermittedParameters
	extend ActiveSupport::Concern

	included do
    before_filter :configure_permitted_parameters
  end

protected

  def configure_permitted_parameters
  	devise_parameter_sanitizer.for(:sign_in) << [:login, :password]
    devise_parameter_sanitizer.for(:sign_up) << [:full_name, :username, :mobile_number, :email, :password]
    devise_parameter_sanitizer.for(:account_update) << [:full_name, :username, :mobile_number, :email, :password]
  end

end

DeviseController.send :include, DevisePermittedParameters