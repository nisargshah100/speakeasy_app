class Room extends Spine.Model
  @configure 'Room', 'name', 'user_id', 'description', 'github_url'
  @extend Spine.Model.Ajax
  @hasMany 'messages', 'Message'

  @url: => "/api/core/rooms"

window.Room = Room