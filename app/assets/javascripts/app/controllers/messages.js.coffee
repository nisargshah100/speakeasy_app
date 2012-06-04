$ = jQuery.sub()
# Message = App.Message
# window.MessagesItem = App.MessagesItem

# $.fn.item = ->
#   elementID   = $(@).data('id')
#   elementID or= $(@).parents('[data-id]').data('id')
#   Message.find(elementID)

class MessagesItem extends Spine.Controller
  # tag: "li"
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
    "click .new button": "create"

  constructor: ->
    super
    Message.bind 'refresh change', @render
    Message.fetch()
    
  render: =>
    messages = Message.all()
    @items.empty()
    Message.each(@addOne)

  addOne: (item) =>
    msgItem = new MessagesItem(item)
    @items.append msgItem.render()
    
  # create: (e) ->
  #   e.preventDefault()
  #   message = Message.fromForm(e.target).save()

  create: ->
      throw "Channel required"  unless @channel
      value = @input.val()
      return false  unless value
      Message.create
        name: @handle
        channel_id: @channel.id
        body: value

      @input.val ""
      @input.focus()
      false

window.Messages = Messages
