# Model = Spine.Model
# window.Room = Room

class Message extends Spine.Model
  @configure 'Message', 'body', 'room_id', 'sid', 'username'
  @extend Spine.Model.Ajax
  @belongsTo 'room', 'Room'

  @url: => "api/core/rooms/#{Sidebar.room().id}/messages"

  # validate: ->
  #   unless @body
  #     alert "Message is required"

  # create: (params, options) ->
  #   # console.log Message
  #   # console.log Spine.Ajax.getURL(Message)
  #   @queue =>
  #     @ajax(
  #       params,
  #       type: 'POST'
  #       data: JSON.stringify(@record)
  #       url:  Ajax.getURL(@model)
  #     ).success(@recordResponse(options))
  #      .error(@errorResponse(options))

  @fetch_all: ->
    Message.deleteAll()
    Message.fetch(url: "/api/core/rooms/#{room.id}/messages") for room in Room.all()

Message.include
  room: ->
    Room.find @room_id

  forRoom: (room) ->
    return false unless room
    @room_id is room.id

window.Message = Message