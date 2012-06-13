$ = jQuery.sub()

class RoomInfo extends Spine.Controller

  constructor: ->
    Sidebar.bind 'joinedRoom', @fetch_room_info

  fetch_room_info: (room_id) =>
    $.get "/api/core/rooms/#{room_id}", (data) =>
      @render(data)

  render: (room) =>
    $("#room-info").empty()
    if room.owner
      $("#room-info").append(@admin_template(room))
    else
      $("#room-info").append(@template(room))

  template: (room) =>
    @view('rooms/info')(room: room)

  admin_template: (room) =>
    @view('rooms/admin_info')(room: room)    

window.RoomInfo = RoomInfo