$ = jQuery.sub()

class Online extends Spine.Controller
  
  constructor: ->
    super
    Room.bind 'refresh_users', @fetch_users_online

  fetch_users_online: (room_id) => 
    $.get "/api/users/connections/", { 'channel': room_id }, (data) =>
      if Sidebar.room().id == room_id
        @users = data
        @render()

  render: =>
    $("#online").html('')
    for user in @users
      $("#online").append("<li>#{user}</li>")

window.Online = Online