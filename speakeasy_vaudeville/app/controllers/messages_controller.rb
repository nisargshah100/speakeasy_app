class MessagesController < ApplicationController
  def index
    @messages = Message.all

    respond_to do |format|
      format.html
      format.json { render json: @messages }
    end
  end

  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @message }
    end
  end

  def new
    @message = Message.new

    respond_to do |format|
      format.html
      format.json { render json: @message }
    end
  end

  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end
end
