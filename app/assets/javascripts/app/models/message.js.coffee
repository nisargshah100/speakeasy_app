class App.Message extends Spine.Model
  @configure 'Message', 'body', 'room_id'
  @extend Spine.Model.Ajax

App.Message.include
  room: ->
    App.Room.find @room_id

  forChannel: (record) ->
    return false  unless record
    @room_id is record.id