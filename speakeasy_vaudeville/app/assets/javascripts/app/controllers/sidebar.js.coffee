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
    $("[data-name=rooms]:first").addClass("current")

  createRoom: ->
    value = @input.val()
    return false  unless value
    Room.create
      name: value
      sid: @id()

    @input.val ""
    @input.focus()
    false

  addOneRoom: (item) =>
    roomItem = new RoomsItem(item)
    @rooms.append roomItem.render()

  addNewRoom: (item) =>
    @addOneRoom(item)

  change: (item) =>
    @deactivate()
    $(item).addClass("current")
    Sidebar.trigger 'changeRoom', Sidebar.room()

  click: (e) =>
    item = $(e.target)
    @change(item)

  deactivate: =>
    $("[data-name]").removeClass("current")

  @room: =>
    id = $(".item.current").attr('id')
    Room.find(id)

  currentChannelEmpty: =>
    return false unless Sidebar.channel() == "Unknown record"

  id: =>
    $("meta[name=current-user-id]").attr("content")

window.Sidebar = Sidebar