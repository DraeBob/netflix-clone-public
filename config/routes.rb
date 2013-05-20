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

  resources :users, only: [:new, :create] do
    #resources :queue_videos
  end
  get '/my_queue', to: "queue_videos#index"
  resources :queue_videos, only: [:create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
