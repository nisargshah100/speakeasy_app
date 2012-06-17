$ = jQuery.sub()

class RoomsItem extends Spine.Controller

  proxied: [ "render", "remove" ]

  template: (room) ->
    @view('rooms/room')(room: room)

  constructor: (@item) ->
    @item.bind "update", @render
    @item.bind "destroy", @remove

  render: =>
    @template(@item)

  remove: ->
    @el.remove()

class Sidebar extends Spine.Controller
  @extend(Spine.Events)

  events:
    "click [data-name]": "click"
    "submit #create-room-form" : "createRoom"

  elements:
    "#rooms": "rooms"
    ".createRoom input": "input"

  constructor: ->
    super
    Room.fetch()
    Room.bind 'refresh', @render
    Room.bind 'create', @addNewRoom
    
  render: =>
    @rooms.empty()
    Room.each(@addOneRoom)
    @initialLoad()

  loadRooms: =>
    Room.delete

  initialLoad: ->
    room_id = parseInt($.cookie('current_room_id') || Room?.first()?.id || -1)
    if room_id == -1
      Room.trigger 'noRoom'
    item = $("[data-name=rooms][id=#{room_id}]")
    @change(item)
    Room.trigger('refresh_users', room_id)

  createRoom: (e) ->
    e.preventDefault()
    name = $("#create_room_name").val()
    desc = $("#create_room_description").val()
    url = $("#create_room_repo").val()
    unless name
      $("#validation").remove()
      $("#room_name").append "<td id='validation'><p>Room name is required</p></td>"
      return false

    unless name.length <= 20
      $("#validation").remove()
      $("#room_name").append "<td id='validation'><p>Room name must be less than 20 characters.</p></td>"
      return false
    
    $.ajax 
      type: "post"
      url: "/api/core/rooms"
      data: $("#create-room-form :input[value][value!='']").serialize()
      success: (data) ->
        Room.deleteAll()
        Room.fetch()
        $("#createRoom").modal('hide')
      error: (data) ->
        alert "Hmm, something went wrong. Refresh the page and try again."

  addOneRoom: (item) =>
    roomItem = new RoomsItem(item)
    @rooms.append roomItem.render()

  addNewRoom: (item) =>
    @addOneRoom(item)

  change: (item) =>
    prev_room_id = $(".current").attr('id');
    current_id = $(item).attr('id')

    return if prev_room_id == current_id

    @deactivate()
    $(item).addClass("current")

    $.ajax {
      url: "/api/users/connections"
      data: { 'connected': current_id, 'disconnected': prev_room_id }
      type: "post"
    }

    $.cookie('current_room_id', current_id)

    Room.trigger 'joined', current_id
    Sidebar.trigger 'leftRoom', prev_room_id
    Sidebar.trigger 'joinedRoom', current_id

  click: (e) =>
    item = $(e.target)
    @change(item)

  deactivate: =>
    $("[data-name]").removeClass("current")

  @room: =>
    id = $(".item.current").attr('id')
    Room.find(id) if id

window.Sidebar = Sidebar