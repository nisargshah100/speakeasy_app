$ = jQuery.sub()
Message = App.Message

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Message.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('messages/new')

  back: ->
    @navigate '/messages'

  submit: (e) ->
    e.preventDefault()
    message = Message.fromForm(e.target).save()
    @navigate '/messages', message.id if message

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Message.find(id)
    @render()
    
  render: ->
    @html @view('messages/edit')(@item)

  back: ->
    @navigate '/messages'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/messages'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Message.find(id)
    @render()

  render: ->
    @html @view('messages/show')(@item)

  edit: ->
    @navigate '/messages', @item.id, 'edit'

  back: ->
    @navigate '/messages'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Message.bind 'refresh change', @render
    Message.fetch()
    
  render: =>
    messages = Message.all()
    @html @view('messages/index')(messages: messages)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/messages', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/messages', item.id
    
  new: ->
    @navigate '/messages/new'
    
class App.Messages extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/messages/new':      'new'
    '/messages/:id/edit': 'edit'
    '/messages/:id':      'show'
    '/messages':          'index'
    
  default: 'index'
  className: 'stack messages'