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
    "#welcome": "welcome"

  events:
    "click .new input#scroll": "createMessage"

  constructor: ->
    super
    Room.bind 'refresh', @loadMessages
    Room.bind 'noRoom', @renderWelcome
    Message.bind 'create', @addNew
    Message.bind 'refresh', @render
    Sidebar.bind 'joinedRoom', @changeRoom
    
  render: =>
    Message.all()
    @items.empty()
    Message.each(@addOne)
    @scroll()

  renderWelcome: =>
    @welcome.empty()
    @welcome.append @welcomeTemplate(@username())
    @welcome.show()

  welcomeTemplate: (username) =>
    @view('messages/welcome')(username: username)

  loadMessages: =>
    Message.fetch_all()

  scroll: =>
    objDiv = $("#stuff")[0]
    objDiv.scrollTop = objDiv.scrollHeight

  addOne: (item) =>
    @welcome.empty()
    return unless item.forRoom(Sidebar.room())
    msgItem = new MessagesItem(item)
    html = linkify(msgItem.render())

    @items.append html
    @scroll()

  addNew: (item) =>
    @addOne(item)

  changeRoom: (room) =>
    @welcome.hide()
    @room = room
    @render()
    @renderEmptyRoom()

  renderEmptyRoom: =>
    $.get "/api/core/rooms/#{@room}/messages", (data) =>
      if data.length == 0
        @welcome.empty()
        @welcome.append @emptyTemplate(@username())
        @welcome.show()

  emptyTemplate: (username) =>
    @view('messages/empty_room')(username: username)
        
  createMessage: ->
    unless Sidebar.room()
      alert "You need to enter a room before you can start chatting!"
      $('#chat_message').val('')
      return false

    url = Message.url()
    value = @input.val()
    return false unless value

    $.post url, {
      sid: @sid()
      'message[body]': value
    }, (data) =>
      data['sid'] = @sid()
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
