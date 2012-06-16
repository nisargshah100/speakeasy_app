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
      @inviteModal = new InviteModal( {el: $("#invite"), room} )
      @editModal = new EditModal( {el: $("#editRoom"), room} )
    else
      $("#room-info").append(@template(room))
      @inviteModal = new InviteModal( {el: $("#invite"), room} )

  template: (room) =>
    @view('rooms/room_info')(room: room)

  admin_template: (room) =>
    @view('rooms/admin_room_info')(room: room)

class EditModal extends Spine.Controller

  events:
    "submit #edit-room-form" : "updateRoom"

  elements:
    ".modal-header" : "header"
    ".modal-body"   : "body"

  constructor: (params) ->
    super
    @room = params.room
    @render()

  render: =>
    @body.append(@template())

  template: =>
    @view('rooms/edit_modal')(room: @room)

  updateRoom: (e) =>
    e.preventDefault()
    name = $("#edit_room_name").val()
    desc = $("#edit_room_description").val()
    url = $("#edit_room_repo").val()
    return false unless name || desc || url
    
    $.ajax 
      type: "put"
      url: "/api/core/rooms/#{@room.id}"
      data: $("#edit-room-form :input[value][value!='']").serialize()
      success: (data) =>
        console.log "updated."
        Room.deleteAll()
        Room.fetch()
        $("#editRoom").modal('hide')
      error: (data) =>
        console.log "not updated."

class InviteModal extends Spine.Controller

  elements:
    ".modal-header" : "header"
    ".modal-body"   : "body"

  events:
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
    @view('rooms/invite_modal')(room: @room, permissions: @permissions)

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
        message = JSON.parse(data.responseText)["message"]
        $("#invite-result").empty()
        $("#invite-result").append "<td><p>#{message}</p></td>"

    @inviteInput.val ""
    @inviteInput.focus()
    false

  addOneMember: (email) =>
    $("#invite-result").empty()
    $("#invite-result").append "<td><p>#{email} has been added!</p></td>"
    $("#invited-members").append "<li>#{email}</li>"

window.RoomInfo = RoomInfo