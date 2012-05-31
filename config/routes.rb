Vaudeville::Application.routes.draw do
  resources :home, only: [:index]

  resources :messages
  resources :rooms

  root to: "home#index"
end
