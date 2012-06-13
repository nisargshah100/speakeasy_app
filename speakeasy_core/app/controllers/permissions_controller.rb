class PermissionsController < ApplicationController
  before_filter :find_room, :authenticate_user, :confirm_room_owner

  def create
    find_invitee(params[:email])
    permission = @room.permissions.new(params[:permission])
    permission.sid = @invitee["sid"]
    if permission.save
      head status: :created, :location => [@room, permission]
    else
      head status: :bad_request
    end
  end

  def destroy
    @room.permissions.where(id: params[:id]).first.destroy
    head status: :ok
  end

  private

  def find_invitee(email)
    @invitee ||= AuthService.get_user_by_email(email)
  end

  def confirm_room_owner
    unless @user.sid == @room.sid
      head status: :unauthorized
    end
  end
end
