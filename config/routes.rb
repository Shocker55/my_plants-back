Rails.application.routes.draw do
  get '/health_check', to: 'health_checks#index'
  namespace :api do
    namespace :v1 do
      post "/auth", to: "authentications#create"
      resources :users, only: %i[index show create] do
        # 非ログイン状態のユーザーにも特定のユーザーの情報を表示したいためparamsのidからユーザーを取得
        member do
          get :likes
          get :attend
        end
        # ログインしているユーザーのブックマークのみを表示したいのでログイン状態のユーザーはheadderから取得するためparamsにidはいらない
        collection do
          get :record_bookmarks
          get :event_bookmarks
          get :widget
        end
      end
      resources :profiles, only: %i[create update]
      resources :records, only: %i[index show create destroy] do
        resources :record_comments, only: %i[create]
        get :related_records
      end
      resources :record_comments, only: %i[destroy]
      resources :record_bookmarks, only: %i[create destroy]
      resources :record_likes, only: %i[create destroy]

      resources :events, only: %i[index show create update destroy] do
        resources :event_comments, only: %i[create]
        resources :event_attendees, only: %i[index]
      end
      resources :event_comments, only: %i[destroy]
      resources :event_bookmarks, only: %i[create destroy]
      resources :event_attendees, only: %i[create destroy]
    end
  end
end
