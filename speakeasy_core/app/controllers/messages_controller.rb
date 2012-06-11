class MessagesController < ApplicationController
  before_filter :find_room, :authenticate_user

  def index
    if @room
      @messages = attach_usernames_to(@room.recent_messages)
    else
      head status: :not_found
    end
  end

  def create
    if @room
      message = @room.messages.build(params[:message])
      message.sid = @user.sid

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

  def attach_usernames_to(messages)
    username_array = get_username_array_for(messages)
    messages.each_with_index { |message, index| message.username = username_array[index] }
  end

  def get_username_array_for(messages)
   users = AuthService.get_users_by_sid(messages.map { |message| message.sid })
   users.map { |user| user ? user['name'] : "" }
  end
end
