Bouncer::Application.routes.draw do
  namespace :api do
    resources :users do
      collection do
        get '/sids/' => 'users#show_by_sids'

        resources :sessions
        resources :connections
      end
    end
  end
end
