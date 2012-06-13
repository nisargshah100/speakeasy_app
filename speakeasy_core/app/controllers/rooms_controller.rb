class RoomsController < ApplicationController
  before_filter :authenticate_user
  before_filter :find_room, :verify_room_owner, only: [:update, :destroy]

  def index
    @rooms = Room.for_user(@user.sid)
  end

  def show
    @room = Room.find(params[:id])
  end

  def create
    room = Room.new(params[:room])
    room.sid = @user.sid

    if room.save
      render json: room, status: :created, location: [room]
    else
      head status: :bad_request
    end
  end

  def update
    if @room.update_attributes(params[:room])
      head status: :ok, :location => [@room]
    else
      head status: :bad_request
    end
  end

  def destroy
    @room.destroy
    head status: :ok
  end

  private

  def verify_room_owner
    head status: :unauthorized unless @user.sid == @room.sid
  end
end
