$ = jQuery.sub()
# Room = App.Room

class RoomsItem extends Spine.Controller
  tag: "li"
  proxied: [ "render", "remove" ]

  template: (room) ->
    @view('rooms/item')(room: room)

  init: ->
    @item.bind "update", @render
    @item.bind "destroy", @remove

  render: (item) ->
    @item = item if item
    elements = @template(@item)
    @el.replaceWith elements
    @el = elements
    @

  remove: ->
    @el.remove()

class Rooms extends Spine.Controller
  elements:
    ".items": "items"
    "#rooms": "rooms"

  constructor: ->
    super
    Room.bind 'refresh change', @render
    Room.fetch()
    
  render: =>
    rooms = Room.all()
    Room.each(@addOne)

  addOne: (item) =>
    roomsItem = RoomsItem.init(item: item)
    @rooms.append roomsItem.render().el

window.Rooms = Rooms