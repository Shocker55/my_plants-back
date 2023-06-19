Rails.application.routes.draw do
  get '/health_check', to: 'health_check#index'

  resources :blogs, only: %i[index show create]
end
