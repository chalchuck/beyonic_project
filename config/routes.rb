Rails.application.routes.draw do
  # devise_for :users

  devise_for :users, controllers: {
          sessions: 'users/sessions'
        }
  root to: "users#index"

  resources :users do
    member do
      
      # get :mobile_number
      
      get :mobile_number, path: "verify_my_mobile"
      put :mobile_number, path: "verify_my_mobile"
      get :verification_code
      put :verification_cod

      get :authenticate_twoway
      put :authenticate_twoway

      get :verify_number
      put :verify_mobile_number

    end
  end
end