Rails.application.routes.draw do
  # API endpoints
  scope module: :api do
    resource :session, only: [ :create, :destroy ]
    resource :registration, only: [ :create ]
    resources :summaries, only: [ :index, :create ]
    resources :amazon_links, only: [ :index ]
  end

  # Web UI
  root "pages#home"
  get "privacy" => "pages#privacy"
  resources :videos, only: [:index]

  get "up" => "rails/health#show", as: :rails_health_check
end
