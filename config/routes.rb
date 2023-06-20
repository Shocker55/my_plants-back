Rails.application.routes.draw do
  get '/health_check', to: 'health_checks#index'

  resources :blogs, only: %i[index show create]
end
