class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  private
  
  def current_user
    @user ||= AUTH.get_user(cookies[:user])
  end
end