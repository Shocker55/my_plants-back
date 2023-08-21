Rails.application.routes.draw do
  get '/health_check', to: 'health_checks#index'
  namespace :api do
    namespace :v1 do
      post "/auth", to: "authentications#create"
      resources :users, only: %i[index show create]
      resources :profiles, only: %i[create update]
      resources :records, only: %i[index show create]
      resources :record_likes, only: %i[create destroy]
    end
  end
end
