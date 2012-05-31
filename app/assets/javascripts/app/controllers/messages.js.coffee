$ = jQuery.sub()
Message = App.Message

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Message.find(elementID)

class Index extends Spine.Controller
  events:
    'submit form': 'submit'

  constructor: ->
    super
    Message.bind 'refresh change', @render
    Message.fetch()
    
  render: =>
    messages = Message.all()
    @html @view('messages/index')(messages: messages)
    
  submit: (e) ->
    e.preventDefault()
    message = Message.fromForm(e.target).save()
    @navigate '/'
    
class App.Messages extends Spine.Stack
  controllers:
    index: Index
    
  routes:
    '/messages':          'index'
    
  default: 'index'
  className: 'stack messages'
