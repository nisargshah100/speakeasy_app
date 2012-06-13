$ = jQuery.sub()

class Online extends Spine.Controller
  
  constructor: ->
    Room.bind 'refresh_users', @fetch_users_online

  fetch_users_online: (room_id) => 
    $.get "/api/users/connections/", { 'channel': room_id }, (data) =>
      @users = data
      @render()

  render: =>
    $("#online").html('')
    for user in @users
      $("#online").append("<li>#{user}</li>")

window.Online = Online