Rails.application.routes.draw do
  devise_for :users

  root to: "users#index"

  resources :users do
    member do
      
      get :mobile_number
      get :add
      
      put :add_mobile_number
      put :change

      get :verify_number
      put :verify_mobile_number
      
      get :generate_new_token
      put :generate_new_token

      get :cancel_verification
      put :cancel_verification

    end
  end
end