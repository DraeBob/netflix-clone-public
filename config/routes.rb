Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  # I added this 4/28
  root to: 'videos#home'
  get '/home', to: 'videos#home'
  get '/video', to: 'videos#video'

  resources :categories, except: [:edit, :update, :destroy]
end
