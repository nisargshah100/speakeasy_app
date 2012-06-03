class RoomsController < ApplicationController
  def index
    @rooms = Room.all

    respond_to do |format|
      format.html
      format.json { render json: @rooms }
    end
  end
end
