class MessagesController < ApplicationController
  before_filter :find_room, :authenticate_user

  def index
    if @room
      @messages = @room.messages
    else
      head status: :not_found
    end
  end

  def create
    if @room
      message = @room.messages.build(params[:message])
      if message.save
        head status: :created, :location => [@room, message]
      else
        head status: :bad_request
      end
    else
      head status: :not_found
    end
  end

  private

  def find_room
    @room = Room.find_by_id(params[:room_id])
  end

  def authenticate_user
    head status: :unauthorized unless get_user_from_auth_service(cookies['user'])
  end
end
