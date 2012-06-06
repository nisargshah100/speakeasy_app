class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def create
    room = Room.new(params[:room])
    if room.save
      head status: :created, :location => [room]
    else
      head status: :bad_request
    end
  end

  def update
    room = Room.find_by_id(params[:id])
    if room
      if room.update_attributes(params[:room])
        head status: :ok, :location => [room]
      else
        head status: :bad_request
      end
    else
      head status: :not_found
    end
  end

  def destroy
    room = Room.find_by_id(params[:id])
    if room
      room.destroy
      head status: :ok
    else
      head status: :bad_request
    end
  end
end
