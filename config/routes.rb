Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root 'pages#index'

  resources :groups

  resources :messages, only: [:create]
  resources :message_threads, only: [:create, :index]

  resources :songs do
    member do
      post 'copy'
    end
  end
  resources :song_roles
  resources :plays, only: [:create]

  resources :performers do
    resources :songs
    resources :groups
    resources :routines
  end

  resources :users do
    resources :performers
    resources :current_performers, only: :create
  end


  resources :resources
  resources :file_resources
  resources :url_resources

  resources :routines
  resources :set_list_songs

  resources :friendships
end
