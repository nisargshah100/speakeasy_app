$ = jQuery.sub()

class RoomInfo extends Spine.Controller

  constructor: ->
    super
    Sidebar.bind 'joinedRoom', @fetch_room_info

  fetch_room_info: (room_id) =>
    $.get "/api/core/rooms/#{room_id}", (data) =>
      @render(data)

  render: (room) =>
    @el.empty()
    if room.owner
      $("#room-info").append(@admin_template(room))
      @modal = new RoomModal( {el: $("#editRoom"), room} )
    else
      $("#room-info").append(@template(room))

  template: (room) =>
    @view('rooms/info')(room: room)

  admin_template: (room) =>
    @view('rooms/admin_info')(room: room)

class RoomModal extends Spine.Controller

  elements:
    ".modal-header" : "header"
    ".modal-body"   : "body"

  events:
    "click": "save"

  constructor: (params) ->
    super
    @room = params.room
    console.log @room
    @render()

  render: =>
    @body.append(@template())

  template: =>
    @view('rooms/modal')(room: @room)

  save: =>
    alert "saving"

window.RoomInfo = RoomInfo