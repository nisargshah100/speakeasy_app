class App.Room extends Spine.Model
  @configure 'Room', 'name', 'user_id', 'description'
  @extend Spine.Model.Ajax

App.Room.include
  messages: ->
      room_id = @id
      App.Message.select (m) ->
        m.room_id is room_id
