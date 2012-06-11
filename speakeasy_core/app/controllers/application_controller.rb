class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :json

  def get_user_from_auth_service(user_token)
    AuthService.get_user(user_token)
  end

  def find_room
    head status: 404 unless @room = Room.find_by_id(params[:room_id] || params[:id])
  end

  def authenticate_user
    unless @user = get_user_from_auth_service(cookies['user'])
      head status: :unauthorized
    end
  end
end
