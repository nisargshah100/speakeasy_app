Vaudeville::Application.routes.draw do
  resources :app, only: [:index]
  resources :home, only: [:index]

  # resources :messages
  # resources :rooms

  root to: "home#index"
end
