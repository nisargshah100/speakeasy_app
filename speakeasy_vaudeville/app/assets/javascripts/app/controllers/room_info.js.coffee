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
      @inviteModal = new InviteModal( {el: $("#invite"), room, admin: true} )
      @editModal = new EditModal( {el: $("#editRoom"), room} )
    else
      $("#room-info").append(@template(room))
      @inviteModal = new InviteModal( {el: $("#invite"), room} )

  template: (room) =>
    @view('rooms/room_info')(room: room)

  admin_template: (room) =>
    @view('rooms/admin_room_info')(room: room)

class EditModal extends Spine.Controller
  @extend(Spine.Events)

  events:
    "submit #edit-room-form" : "updateRoom"
    "click #delete-room" : "deleteRoom"

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

  deleteRoom: =>
    if confirm "Are you sure you want to delete #{@room.name}?"

      $.ajax 
        type: "delete"
        url: "/api/core/rooms/#{@room.id}"
        success: (data) =>
          $.cookie('current_room_id', null)
          Room.deleteAll()
          Room.fetch()
          @el.modal('hide')
        error: (data) =>
          alert "Hmm, something went wrong. Please refresh the page and try again."

  updateRoom: (e) =>
    e.preventDefault()
    name = $("#edit_room_name").val()
    desc = $("#edit_room_description").val()
    url = $("#edit_room_repo").val()
    return false unless name || desc || url

    if name && name.length > 20
      $("#edit_name_hint").children().remove()
      $("#edit_name_hint").append "<h6 class='hint' style='color:red;'>Room name must be less than 20 characters!</h6>"
      return false
    
    $.ajax 
      type: "put"
      url: "/api/core/rooms/#{@room.id}"
      data: $("#edit-room-form :input[value][value!='']").serialize()
      success: (data) =>
        Room.deleteAll()
        Room.fetch()
        @el.modal('hide')
      error: (data) =>
        console.log "not updated."

class InviteModal extends Spine.Controller

  elements:
    ".modal-header" : "header"
    ".modal-body"   : "body"

  events:
    "click #invite-submit" : "inviteMember"
    "click #remove-patron" : "removeMember"

  constructor: (params) ->
    super
    @admin = params.admin
    @room = params.room
    @getPermissions()

  getPermissions: =>
    $.get "/api/core/rooms/#{@room.id}/permissions", (data) =>
      @permissions = data
      @render()

  render: =>
    @body.append(@template())

  template: =>
    if @admin
      @view('rooms/admin_invite_modal')(room: @room, permissions: @permissions)
    else
      @view('rooms/invite_modal')(room: @room, permissions: @permissions)

  removeMember: (e) =>
    @member = $(e.target).parent().attr("data-email")
    @id = $(e.target).parent().attr("@id")
    if confirm "Are you sure you want to remove #{@member} from #{@room.name}?"
      
      $.ajax
        type: "delete"
        url: "/api/core/rooms/#{@room.id}/permissions/#{@id}"
        data: { "email": @member }
        success: (data) =>
          $("#invite-result").empty()
          $(e.target).parent().remove()
          $("#invite-result").append "<td><p id='invite-notice'>#{@member} has been removed!</p></td>"
        error: ->
          $("#invite-result").empty()
          $("#invite-result").append "<td><p id='invite-notice'>Hmm, something went wrong. Try refreshing the page.</p></td>"

  inviteMember: =>
    @inviteInput = $("#invite-input")
    value = @inviteInput.val()
    return false unless value

    $.ajax 
      type: "post"
      url: "/api/core/rooms/#{@room.id}/permissions"
      data: { "email": value }
      success: (data) =>
        @addOneMember(value, data)
      error: (data) =>
        message = JSON.parse(data.responseText)["message"]
        $("#invite-result").empty()
        $("#invite-result").append "<td><p id='invite-notice' style='color:red;'>#{message}</p></td>"

    @inviteInput.val ""
    @inviteInput.focus()
    false

  addOneMember: (email, data) =>
    $("#invite-result").empty()
    $("#invite-result").append "<td><p id='invite-notice'>#{email} has been added!</p></td>"
    $("#invited-members").append @memberTemplate(email, data)

  memberTemplate: (email, data)=>
    @view('rooms/member')(email: email, data: data, admin: @admin)

window.RoomInfo = RoomInfo