Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'videos#index'
  resources :videos, only: [:index, :show]
  resources :categories, except: [:edit, :update, :destroy]
  get '/search', to: 'videos#search'
end
