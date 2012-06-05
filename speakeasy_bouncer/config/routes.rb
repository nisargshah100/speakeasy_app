Bouncer::Application.routes.draw do
  namespace :api do
    resources :users do
      collection do
        resources :sessions
      end
    end
  end
end
