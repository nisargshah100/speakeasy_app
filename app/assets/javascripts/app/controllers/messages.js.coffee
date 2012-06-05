$ = jQuery.sub()
# Message = App.Message
# window.MessagesItem = App.MessagesItem

# $.fn.item = ->
#   elementID   = $(@).data('id')
#   elementID or= $(@).parents('[data-id]').data('id')
#   Message.find(elementID)

class MessagesItem extends Spine.Controller
  proxied: [ "render", "remove" ]

  template: (message) ->
    @view('messages/message')(message: message)

  constructor: (@item) ->
    @item.bind "update", @render
    @item.bind "destroy", @remove

  render: =>
    @template(@item)

  remove: ->
    @el.remove()

class Messages extends Spine.Controller

  elements:
    ".items": "items"
    ".new textarea": "input"

  events:
    "click .new input[type='submit']": "create"

  constructor: ->
    super
    Message.bind 'create', @addNew
    Message.bind 'refresh', @render
    Sidebar.bind 'changeRoom', @changeRoom
    Message.fetch()
    
  render: =>
    messages = Message.all()
    @items.empty()
    Message.each(@addOne)

  addOne: (item) =>
    return unless item.forRoom(Sidebar.room())
    msgItem = new MessagesItem(item)
    @items.append msgItem.render()

  addNew: (item) =>
    @addOne(item)
    
  changeRoom: (room) =>
    @room = room
    @render()

  create: ->
    throw "Room required"  unless Sidebar.room()
    value = @input.val()
    return false  unless value
    Message.create
      user_id: 1
      room_id: Sidebar.room().id
      body: value

    @input.val ""
    @input.focus()
    false

window.Messages = Messages
