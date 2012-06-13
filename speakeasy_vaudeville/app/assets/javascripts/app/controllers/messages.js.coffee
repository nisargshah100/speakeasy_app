$ = jQuery.sub()
# Message = App.Message
# window.MessagesItem = App.MessagesItem

# $.fn.item = ->
#   elementID   = $(@).data('id')
#   elementID or= $(@).parents('[data-id]').data('id')
#   Message.find(elementID)

class MessagesItem extends Spine.Controller
  #proxied: [ "render", "remove" ]

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
    "click .new input#scroll": "createMessage"

  constructor: ->
    super
    Room.bind 'refresh', @loadMessages
    Message.bind 'create', @addNew
    Message.bind 'refresh', @render
    Sidebar.bind 'joinedRoom', @changeRoom
    
  render: =>
    Message.all()
    @items.empty()
    Message.each(@addOne)
    @scroll()

  loadMessages: =>
    Message.fetch_all()

  scroll: =>
    objDiv = $("#stuff")[0]
    objDiv.scrollTop = objDiv.scrollHeight

  addOne: (item) =>
    return unless item.forRoom(Sidebar.room())
    msgItem = new MessagesItem(item)
    html = linkify(msgItem.render())

    @items.append html
    @scroll()

  addNew: (item) =>
    @addOne(item)

  changeRoom: (room) =>
    @room = room
    @render()

  createMessage: ->
    alert "Room required" unless Sidebar.room()
    url = Message.url()
    value = @input.val()
    return false unless value

    $.post url, {
      sid: @sid()
      'message[body]': value
    }, (data) =>
      new Message(data).publish()

    @input.val ""
    @input.focus()
    false

  sid: =>
    $("meta[name=current-sid]").attr('content')

  username: =>
    $("meta[name=current-user-name]").attr("content")

  email: => 
    $("meta[name=current-user-email]").attr("content")

window.Messages = Messages
