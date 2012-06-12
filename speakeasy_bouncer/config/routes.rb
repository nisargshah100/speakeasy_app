Bouncer::Application.routes.draw do
  namespace :api do
    resources :users do
      collection do
        resources :sessions
        resources :connections
      end
    end
  end
end
