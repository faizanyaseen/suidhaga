Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  resources :customers do
    member do
      get :measurement_value
    end
  end
  resources :orders do
    member do
      patch :mark_complete
      patch :mark_delivered
      get :print
    end
  end
  resources :measurement_types do
    member do
      get :usage_info
    end
  end
  resources :tailors
  root 'dashboard#index'

  resource :profiles, only: [:show, :update] do
    patch :update_shop
    patch :update_tailor_limit
    delete :remove_logo
  end

  resources :subscriptions, only: [:show, :edit, :update] do
    member do
      patch :upgrade
      patch :downgrade
      patch :cancel
    end
  end
end
