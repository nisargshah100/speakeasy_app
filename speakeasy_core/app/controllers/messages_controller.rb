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
      message = attach_usernames_to([message]).first

      if message.save
        render :json => message, :status => :created
        # head status: :created, :location => [@room, message]
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
   users = SpeakeasyBouncerGem.get_users_by_sid(messages.map { |message| message.sid })
   users.map { |message_user| message_user ? message_user.name : "" }
  end
end
