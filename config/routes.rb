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

  resources :opentimes, only: [ :index, :new, :create ]

  resources :dishes, only: [ :index, :new, :create, :show, :edit, :update ] do
    member do
      patch :activate
      patch :disable
    end

    resources :portions, only: [ :new, :create, :edit, :update] do
      get :price_history, on: :member
    end
  end

  resources :drinks, only: [ :index, :new, :create, :show, :edit, :update ] do
    member do
      patch :activate
      patch :disable
    end

    resources :portions, only: [ :new, :create, :edit, :update] do
      get :price_history, on: :member
    end
  end

  resources :tags, only: [ :index, :new, :create, :destroy ]

  resources :menus
end
