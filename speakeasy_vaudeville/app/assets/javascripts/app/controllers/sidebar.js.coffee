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
    Room.each(@addOneRoom)
    # adds current to the first room everytime render is called
    # we should probably change this behavior

    room_id = parseInt($.cookie('current_room_id') || Room.first().id)
    $("[data-name=rooms][id=#{room_id}]").addClass("current")
    fayeHandler.publishJoinedRoom(Room.find(room_id))

  createRoom: ->
    url = Room.url()
    value = @input.val()
    return false  unless value
    
    $.post "/api/core/rooms", {
      room: { name: value }
    }, (data) =>
      Room.deleteAll()
      @rooms.empty()
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

    fayeHandler.publishLeftRoom(Room.find(prev_room_id))
    fayeHandler.publishJoinedRoom(Room.find(current_id))
    $.cookie('current_room_id', current_id)

    Sidebar.trigger 'changeRoom', Sidebar.room()

  click: (e) =>
    item = $(e.target)
    @change(item)

  deactivate: =>
    $("[data-name]").removeClass("current")

  @room: =>
    id = $(".item.current").attr('id')
    Room.find(id)

  # sid: =>
  #   $("meta[name=current-sid]").attr('content')

  currentChannelEmpty: =>
    return false unless Sidebar.channel() == "Unknown record"

window.Sidebar = Sidebar