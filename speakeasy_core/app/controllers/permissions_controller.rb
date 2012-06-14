class PermissionsController < ApplicationController
  before_filter :find_room, :authenticate_user, :confirm_room_owner

  def index
    if @room
      @permissions = attach_emails_to(@room.permissions)
    else
      head status: :bad_found
    end
  end

  def create
    permission = @room.permissions.new(params[:permission])
    permission.sid = invitee.sid
    if permission.save
      head status: :created, :location => [@room, permission]
    else
      head status: :bad_request
    end
  end

  def destroy
    @room.permissions.where(sid: invitee.sid).first.destroy
    head status: :ok
  end

  private

  def invitee
    @invitee ||= SpeakeasyBouncerGem.get_user_by_email(params[:email])
  end

  def confirm_room_owner    
    head status: :unauthorized unless @user.sid == @room.sid
  end

  def attach_emails_to(permissions)
    username_array = get_username_array(permissions)
    permissions.each_with_index { |permission, index| permission.email = username_array[index] }
  end

  def get_username_array(permissions)
   users = SpeakeasyBouncerGem.get_users_by_sid(permissions.map { |permission| permission.sid })
   users.map { |message_user| message_user ? message_user.email : "" }
  end
end
