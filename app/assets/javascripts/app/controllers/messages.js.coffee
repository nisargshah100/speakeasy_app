$ = jQuery.sub()
# Message = App.Message
# window.MessagesItem = App.MessagesItem

# $.fn.item = ->
#   elementID   = $(@).data('id')
#   elementID or= $(@).parents('[data-id]').data('id')
#   Message.find(elementID)

class MessagesItem extends Spine.Controller
  # tag: "li"
  el: $("li")
  proxied: [ "render", "remove" ]
  
  # template: (data) ->
  #   $("#messageTemplate").tmpl data

  template: (message) ->
    @view('messages/item')(message: message)

  constructor: (@item) ->
    @item.bind "update", @render
    @item.bind "destroy", @remove

  render: =>
    elements = @template(@item)
    @el.replaceWith elements
    @el = elements
    return this

  remove: ->
    @el.remove()

class Messages extends Spine.Controller

  elements:
    ".items": "items"
    ".new textarea": "input"

  events:
    'submit form': 'submit'

  constructor: ->
    super
    Message.bind 'refresh change', @render
    Message.fetch()
    
  render: =>
    messages = Message.all()
    Message.each(@addOne)

  addOne: (item) =>
    # msgItem = MessagesItem.init(item: item)
    msgItem = new MessagesItem(item)
    @items.append msgItem.render().el
    
  submit: (e) ->
    e.preventDefault()
    message = Message.fromForm(e.target).save()

window.Messages = Messages
    
# class App.Messages extends Spine.Stack
#   controllers:
#     index: App.MessagesIndex
    
#   routes:
#     '/messages':          'index'
    
#   className: 'stack messages'
