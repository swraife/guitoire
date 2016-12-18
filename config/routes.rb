Rails.application.routes.draw do
  devise_for :users

  root 'pages#index'
  resources :users do
    resources :songs
  end
end
