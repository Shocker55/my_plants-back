Rails.application.routes.draw do
  get '/health_check', to: 'health_checks#index'
  namespace :api do
    namespace :v1 do
      post "/auth", to: "authentications#create"
      resources :blogs, only: %i[index show create]
      resources :users, only: %i[index show create]
    end
  end
end
