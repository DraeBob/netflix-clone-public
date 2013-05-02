Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

 
   root to: 'videos#index'
  # get '/home', to: 'videos#home'
  # get '/video/:id', to: 'videos#video'

  resources :videos

  resources :categories, except: [:edit, :update, :destroy]
end
