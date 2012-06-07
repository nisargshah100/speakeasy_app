#= require pusher

$ = jQuery

class PusherHandler extends Spine.Module

  constructor: (@options = {}) ->
    @options.key or= $('meta[name=pusher-key]').attr('content')

    @pusher = new Pusher(@options.key, @options)

    $.ajaxSetup
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'X-Session-ID', @pusher.connection.socket_id

    @channel = @pusher.subscribe 'testing'
    @channel.bind_all @processWithoutAjax

  process: (type, msg) =>
    if msg
      klass = eval(msg.class)
    else
    switch type
      when 'create'
        console.log klass.exists(msg.record.id)
        klass.create msg.record unless klass.exists(msg.record.id)
      when 'test'
        console.log klass
      else
        console.log type

  processWithoutAjax: =>
    args = arguments
    Spine.Ajax.disable =>
      @process(args...)

$ -> new PusherHandler