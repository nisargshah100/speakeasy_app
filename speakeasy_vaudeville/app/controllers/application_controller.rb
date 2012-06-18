class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  private

  def current_user
    @user ||= SpeakeasyBouncerGem.get_user(cookies[:user])
  end

  def require_login!
    unless current_user.sid
      redirect_to root_url
      false
    end
  end
end
