SpeakeasyCheque::Application.routes.draw do
  resource :dashboard
  root to: "dashboards#show"
end
