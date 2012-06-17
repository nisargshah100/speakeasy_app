class Message extends Spine.Model
  @configure 'Message', 'body', 'room_id', 'sid', 'username', 'plain'
  @extend Spine.Model.Ajax
  @belongsTo 'room', 'Room'

  @url: => "api/core/rooms/#{Sidebar.room().id}/messages"

  publish: (room = @room_id) ->
    data =
      body: @body
      room_id: room
      username: @username
      sid: @sid

    console.log(data)

    fayeHandler.publishToRoom(Room.find(room), data)

  @fetch_all: ->
    Message.deleteAll()
    Message.fetch(url: "/api/core/rooms/#{room.id}/messages") for room in Room.all()

Message.include
  room: ->
    Room.find @room_id

  forRoom: (message) ->
    return false unless message
    @room_id is message.id

window.Message = Message