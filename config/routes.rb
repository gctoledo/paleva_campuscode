Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_for :users, controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations'
}

  root to: "home#index"

  resource :restaurants, only: [ :new, :create ]
  resources :opentimes, only: [ :index, :new, :create ]
  resources :dishes, only: [ :index, :new, :create, :show, :edit, :update ]
  resources :drinks, only: [ :index, :new, :create, :show, :edit, :update ]
end
