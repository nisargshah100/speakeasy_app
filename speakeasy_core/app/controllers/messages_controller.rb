class MessagesController < ApplicationController
  def index
    room = Room.where(id: params["room_id"]).first
    if room
      @messages = room.messages
    else
      render status: :bad_request, json: "Invalid Room"
    end
  end

  def create
    room = Room.where(id: params["room_id"]).first
    if room
      message = room.messages.build(body: params["body"])
      if message.save
        render status: :created, json: "Message Created"
      else
        render status: :bad_request, json: "Bad Request"
      end
    else
      render status: :bad_request, json: "Room does not exist"
    end
  end
end
