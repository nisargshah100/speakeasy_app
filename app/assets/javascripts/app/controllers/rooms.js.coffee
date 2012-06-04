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
    $("[data-name=rooms]:first").addClass("current")
    @log Sidebar.channel()

  change: (item) =>
    @deactivate()
    $(item).addClass("current")
    Sidebar.channel()

  click: (e) =>
    item = $(e.target).parent()
    @change(item)

  deactivate: =>
    $("[data-name]").removeClass("current")

  addOne: (item) =>
    roomItem = new RoomsItem(item)
    @rooms.append roomItem.render()

  @channel: =>
    id = $(".item.current").first().children().first().attr('id')
    Room.find(id)

  currentChannelEmpty: =>
    return false unless Sidebar.channel() == "Unknown record"

window.Sidebar = Sidebar