Rails.application.routes.draw do
  devise_for :users

  root 'pages#index'

  resources :users do
    resources :songs
  end
  resources :songs

  resources :song_roles

  resources :file_resources
  resources :url_resources

  resources :set_lists
  resources :song_resources
end
