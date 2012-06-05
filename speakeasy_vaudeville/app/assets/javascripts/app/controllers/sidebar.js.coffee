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
    Room.bind 'refresh', @render
    Room.bind 'create', @addNew
    Room.fetch()
    
  render: =>
    Room.each(@addOne)
    # adds current to the first room everytime render is called
    # we should probably change this behavior
    $("[data-name=rooms]:first").addClass("current")

  createRoom: ->
    value = @input.val()
    return false  unless value
    Room.create
      name: value
      user_id: 1

    @input.val ""
    @input.focus()
    false

  addOne: (item) =>
    roomItem = new RoomsItem(item)
    @items.append roomItem.render()

  addNew: (item) =>
    @addOne(item)

  change: (item) =>
    @deactivate()
    $(item).addClass("current")
    Sidebar.trigger 'changeRoom', Sidebar.room()

  click: (e) =>
    item = $(e.target)
    @change(item)

  deactivate: =>
    $("[data-name]").removeClass("current")

  addOne: (item) =>
    roomItem = new RoomsItem(item)
    @rooms.append roomItem.render()

  @room: =>
    id = $(".item.current").attr('id')
    Room.find(id)

  currentChannelEmpty: =>
    return false unless Sidebar.channel() == "Unknown record"

window.Sidebar = Sidebar