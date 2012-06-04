class RoomsController < ApplicationController
  def index
    @rooms = Room.all

    respond_to do |format|
      format.html
      format.json { render json: @rooms }
    end
  end

  def show
    @room = Room.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @room }
    end
  end

  def new
    @room = Room.new

    respond_to do |format|
      format.html
      format.json { render json: @room }
    end
  end

  def create
    @room = Room.new(params[:room])

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render json: @room, status: :created, location: @room }
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end
end
