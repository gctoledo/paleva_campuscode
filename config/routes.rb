Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users, controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations'
}

  root to: "menus#index"

  get 'search', to: 'search#index'
  
  resource :restaurants, only: [ :new, :create ]

  resources :opentimes, only: [ :index, :new, :create, :edit, :update ]

  resources :dishes do
    member do
      patch :activate
      patch :disable
    end

    resources :portions, only: [ :new, :create, :edit, :update ] do
      get :price_history, on: :member
    end
  end

  resources :drinks do
    member do
      patch :activate
      patch :disable
    end

    resources :portions, only: [ :new, :create, :edit, :update ] do
      get :price_history, on: :member
    end
  end

  resources :tags, only: [ :index, :new, :create, :destroy ]

  resources :menus do
    resources :orders, only: [ :new, :create ]
  end

  resources :orders, only: [ :index, :show, :new, :create ]

  resources :pre_registered_users, only: [:index, :new, :create]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :restaurants, only: [], param: :code do
        resources :orders, only: [:index, :show], param: :code do
          member do
            patch :preparing
            patch :ready
            patch :cancel
          end
        end
      end
    end
  end

  resources :track_orders, controller: 'public_orders', only: [:index, :show], param: :code do
    collection do
      post :search
    end
  end
    
end
