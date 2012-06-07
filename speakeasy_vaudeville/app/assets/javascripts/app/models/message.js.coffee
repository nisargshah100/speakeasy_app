# Model = Spine.Model
# window.Room = Room

class Message extends Spine.Model
  @configure 'Message', 'body', 'room_id'
  @extend Spine.Model.Ajax
  @belongsTo 'room', 'Room'

  @url: 'api/core/messages/'

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

Message.include
  room: ->
    Room.find @room_id

  forRoom: (message) ->
    return false unless message
    @room_id is message.id

window.Message = Message