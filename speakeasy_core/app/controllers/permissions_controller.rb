class PermissionsController < ApplicationController
  before_filter :find_room, :authenticate_user, :confirm_room_owner

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
    #raise Permission.all.inspect
    #raise @room.permissions.where(sid: invitee.sid).inspect
    @room.permissions.where(sid: invitee.sid).first.destroy
    head status: :ok
  end

  private

  def invitee
    @invitee ||= AuthService.get_user_by_email(params[:email])
  end

  def confirm_room_owner
    unless @user.sid == @room.sid
      head status: :unauthorized
    end
  end
end
