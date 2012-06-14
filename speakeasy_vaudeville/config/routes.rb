Vaudeville::Application.routes.draw do
  resources :app, only: [:index]
  resources :home, only: [:index]
  root to: "home#index"
end
