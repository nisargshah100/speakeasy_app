class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :json

  def get_user_from_auth_service(user_token)
    AuthService.get_user(user_token)
  end
end
