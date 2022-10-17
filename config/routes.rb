Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'
  get '/analize', to: 'articles#new'
  post '/analize', to: 'articles#create'
  get 'articles', to: 'articles#index'
end
