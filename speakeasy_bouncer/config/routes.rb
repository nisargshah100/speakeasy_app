Bouncer::Application.routes.draw do
  namespace :api do
    resources :users do
      collection do
        get '/sids/' => 'users#show_by_sids'
        get '/email/' => 'users#show_by_email'
        get '/gravatar/:id' => 'gravatars#show'

        resources :sessions
        resources :connections
      end
    end
  end
end
