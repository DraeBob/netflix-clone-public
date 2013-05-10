Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'sessions#index'
  
  resources :videos, only: [:index, :show]
  resources :categories, except: [:edit, :update, :destroy]

  get '/search', to: 'videos#search'

  resources :users, only: [:new, :create]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
