Vaudeville::Application.routes.draw do
  resources :app, only: [:index]

  resources :messages
  resources :rooms

  root to: "app#index"
end
