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
    "click .createRoom button": "createRoom"

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

  createRoom: ->
    url = Room.url()
    value = @input.val()
    return false  unless value
    
    $.post "/api/core/rooms", {
      room: { name: value }
    }, (data) =>
      Room.deleteAll()
      Room.fetch()

    @input.val ""
    @input.focus()
    false

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