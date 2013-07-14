Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'sessions#index'

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :panels, only: [:index]
  end

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

  get '/forgot_password', to: 'forgot_passwords#new'
  resources :forgot_passwords, only: [:create]
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'

  resources :password_resets, only: [:show, :create]
  get '/expired_token', to: 'password_resets#expired_token'

  get '/invite', to: 'invitations#new'
  resources :invitations, only: [:create]
  get 'new_user/:token', to: 'users#new_with_invitation_token', as: 'new_user_with_token'
end
