Rails.application.routes.draw do
  devise_for :users

  root 'pages#index'
  resources :users do
    resources :songs
  end

  resources :set_lists
end
