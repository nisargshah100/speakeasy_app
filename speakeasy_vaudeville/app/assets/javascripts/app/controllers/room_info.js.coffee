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
    "click #invite-submit" : "inviteMember"

  constructor: (params) ->
    super
    @room = params.room
    @getPermissions()

  getPermissions: =>
    $.get "/api/core/rooms/#{@room.id}/permissions", (data) =>
      @permissions = data
      @render()

  render: =>
    @body.append(@template())

  template: =>
    @view('rooms/modal')(room: @room, permissions: @permissions)

  inviteMember: =>
    @inviteInput = $("#invite-input")
    value = @inviteInput.val()
    return false unless value

    $.ajax 
      type: "post"
      url: "/api/core/rooms/#{@room.id}/permissions"
      data: { "email": value }
      success: (data) =>
        @addOneMember(value)
      error: (data) =>
        $("#invite-result").empty()
        $("#invite-result").append "<td><p>Couldn't add that user!</p></td>"

    @inviteInput.val ""
    @inviteInput.focus()
    false

  addOneMember: (email) =>
    $("#invite-result").empty()
    $("#invite-result").append "<td><p>#{email} has been added!</p></td>"
    $("#invited-members").append "<li>#{email}</li>"

window.RoomInfo = RoomInfo