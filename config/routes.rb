Rails.application.routes.draw do
  # API endpoints
  scope module: :api do
    resource :session, only: [ :create, :destroy ]
    resource :registration, only: [ :create ]
    resources :summaries, only: [ :index, :create ]
  end

  # Web UI
  root "videos#index"
  resources :videos, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check
end
