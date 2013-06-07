Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'sessions#index'
  
  resources :videos, only: [:index, :show] do
    collection do
      post :search , to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :categories, except: [:edit, :update, :destroy]
  resources :users, only: [:show, :new, :create]

  get '/my_queue', to: "queue_videos#index"
  resources :queue_videos, only: [:create, :destroy]
  post '/update_queue', to: 'queue_videos#update_queue'

  resources :followerships, only: [:index, :create, :destroy]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/forgot_password', to: 'users#forgot_password'
  put '/password_reset_token', to: 'users#password_reset_token'
  get '/confirm_password_reset', to: 'users#confirm_password_reset'
  get '/reset_password/:token', to: 'users#reset_password', as: :reset_password
  put '/reset_password/:token', to: 'users#reset_password'
  get '/invalid_token', to: 'users#invalid_token'
end
