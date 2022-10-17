Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'
  resources :articles, only: %i[index new create]
  get 'articles/:article_id/comments', to: 'comments#index', as: :article_comments
end
