class Message extends Spine.Model
  @configure 'Message', 'body', 'room_id'
  @extend Spine.Model.Ajax

  @url: 'api/core/rooms/:room_id/messages'

  validate: ->
    unless @body
      alert "Message is required"

Message.include
  room: ->
    Room.find @room_id

  forRoom: (message) ->
    return false unless message
    @room_id is message.id

window.Message = Message