Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root 'pages#index'

  get '/search' => 'search#search'
  resources :groups

  resources :messages, only: [:create]
  resources :message_threads, only: [:create, :index]

  resources :feats do
    member do
      post 'copy'
    end
  end
  resources :feat_roles
  resources :plays, only: [:create]

  resources :performers do
    resources :feats
    resources :groups
    resources :routines
  end

  resources :users do
    resources :current_performers, only: :create
    resources :performers, controller: 'user_performers'
  end


  resources :resources
  resources :file_resources
  resources :url_resources

  resources :routines
  resources :routine_feats

  resources :followers
end
