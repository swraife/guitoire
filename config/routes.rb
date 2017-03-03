Rails.application.routes.draw do
  devise_for :users

  root 'pages#index'

  resources :messages, only: [:create]
  resources :message_threads, only: [:create, :index]

  resources :songs do
    resources :plays, only: [:create]
  end
  resources :song_roles

  resources :users do
    resources :songs
  end

  resources :resources
  resources :file_resources
  resources :url_resources

  resources :routines
  resources :set_list_songs
end
