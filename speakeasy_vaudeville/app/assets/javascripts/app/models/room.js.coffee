class Room extends Spine.Model
  @configure 'Room', 'name', 'user_id', 'description'
  @extend Spine.Model.Ajax
  @hasMany 'messages', 'Message'

  @url: => "/api/core/rooms"

  Room.include
    isEmpty: ->
      room_id = @id
      @messages = Message.select (m) ->
        m.room_id is room_id
      if @messages.length == 0
        return true

# Room.include
#   messages: ->
#     room_id = @id
#     Message.select (m) ->
#       m.room_id is room_id

window.Room = Room