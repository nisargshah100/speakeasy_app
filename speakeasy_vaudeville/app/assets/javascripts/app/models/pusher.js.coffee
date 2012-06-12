#= require pusher

$ = jQuery

class PusherHandler extends Spine.Module

  constructor: (@options = {}) ->
    @pusher = PusherHandler.pusher(@options)

    $.ajaxSetup
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'X-Session-ID', @pusher.connection.socket_id

    Room.bind 'refresh', @subscribeToChannels
    # Room.bind 'create', @subscribeToChannel

  @pusher: (@options = {}) =>
    @options.key or= $('meta[name=pusher-key]').attr('content')
    new Pusher(@options.key, @options)

  subscribeToChannel: (room) =>
    @channel = @pusher.subscribe room.id.toString()
    @channel.bind_all @processWithoutAjax

  subscribeToChannels: =>
    @rooms = Room.all()
    for room in @rooms
      @subscribeToChannel(room)

  process: (type, msg) =>
    if msg
      klass = eval(msg.class)
    else
    switch type
      when 'create'
        klass.create msg.record unless klass.exists(msg.record.id)
      when 'connected'
        Spine.Ajax.disable =>
          name = msg?.user?.name || "Anonymous"
          channel = parseInt(msg?.channel || "-1")
          Message.create(body: "#{name} joined!", room_id: channel, plain: true)
      when 'disconnected'
        Spine.Ajax.disable =>
          name = msg?.user?.name || "Anonymous"
          channel = parseInt(msg?.channel || "-1")
          Message.create(body: "#{name} disconnected!", room_id: channel, plain: true)
      else
        console.log type

  processWithoutAjax: =>
    args = arguments
    Spine.Ajax.disable =>
      @process(args...)

window.PusherHandler = PusherHandler
$ -> new PusherHandler