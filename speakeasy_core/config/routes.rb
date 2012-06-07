Speakeasy::Application.routes.draw do
  scope "api/core" do
    resources :rooms do
      resources :messages
    end
  end
end
