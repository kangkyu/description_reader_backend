Rails.application.routes.draw do
  resource :session, only: [ :create, :destroy ]
  resource :registration, only: [ :create ]
  resources :summaries, only: [ :index, :create ]

  get "up" => "rails/health#show", as: :rails_health_check
end
