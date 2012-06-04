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
  events:
    "click [data-name]": "click"

  elements:
    "#rooms": "rooms"

  constructor: ->
    super
    Room.bind 'refresh change', @render
    Room.fetch()
    
  render: =>
    rooms = Room.all()
    Room.each(@addOne)

  change: (item) =>
    @deactivate()
    $(item).addClass("current")

  click: (e) =>
    item = $(e.target).parent()
    @change(item)

  deactivate: =>
    console.log $("[data-name]")
    $("[data-name]").removeClass("current")

  addOne: (item) =>
    roomItem = new RoomsItem(item)
    @rooms.append roomItem.render()

window.Sidebar = Sidebar