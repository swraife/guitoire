Rails.application.routes.draw do
  devise_for :users

  root 'pages#index'

  resources :users do
    resources :songs
  end

  resources :file_resources
  resources :url_resources

  resources :set_lists
end
