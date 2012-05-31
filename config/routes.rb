Vaudeville::Application.routes.draw do
  resources :messages
  resources :rooms

  root to: "messages#index"
end
