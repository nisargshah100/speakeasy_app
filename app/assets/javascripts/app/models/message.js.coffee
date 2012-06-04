class Message extends Spine.Model
  @configure 'Message', 'body', 'room_id'
  @extend Spine.Model.Ajax

Message.include
  room: ->
    Room.find @room_id

  forChannel: (record) ->
    return false  unless record
    @room_id is record.id

window.Message = Message