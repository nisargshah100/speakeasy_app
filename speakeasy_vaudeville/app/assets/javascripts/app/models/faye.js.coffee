$ = jQuery

class FayeHandler extends Spine.Module

  constructor: (@url=FayeHandler.url) ->
    @faye ||= new Faye.Client(@url)
    @connected ||= {}

    Room.bind 'refresh', @subscribeToRooms
    @publishJoinedRoom()
    @publishLeftRoom()

  @url:
    "#{window.location.host.replace(':9000', '')}:9292/faye"

  publishToRoom: (room, msg) =>
    @faye.publish "/room/#{room.id}", msg

  publishJoinedRoom: =>
    Sidebar.bind 'joinedRoom', (room_id) =>
      @faye.publish "/room/#{room_id}/joined", { 
        username: $("meta[name=current-user-name]").attr("content"), 
        room_id: room_id 
      }

  publishLeftRoom: =>
    Sidebar.bind 'leftRoom', (room_id) =>
      @faye.publish "/room/#{room_id}/left", { 
        username: $("meta[name=current-user-name]").attr("content"), 
        room_id: room_id
      }

  subscribeToRoom: (room) =>
    if not @connected[room.id]
      @faye.subscribe "/room/#{room.id}/joined", (msg) =>
        Spine.Ajax.disable =>
          @joinedRoom(msg)

      @faye.subscribe "/room/#{room.id}/left", (msg) =>
        Spine.Ajax.disable =>
          @leftRoom(msg)

      @faye.subscribe "/room/#{room.id}", (msg) =>
        Spine.Ajax.disable =>
          msg = Message.create(
            body: msg.body,
            room_id: msg.room_id,
            username: msg.username
          )

      @connected[room.id] = true

  subscribeToRooms: =>
    @rooms = Room.all()
    for room in @rooms
      @subscribeToRoom(room)

  joinedRoom: (msg) =>
    msg = Message.create(
      body: "#{msg?.username || 'Anonymous'} just joined"
      room_id: parseInt(msg?.room_id || -1)
      plain: true
    )

    Room.trigger 'refresh_users', msg.room_id

  leftRoom: (msg) =>
    msg = Message.create(
      body: "#{msg?.username || 'Anonymous'} just left"
      room_id: parseInt(msg?.room_id || -1)
      plain: true
    )

    Room.trigger 'refresh_users', msg.room_id

$ -> 
  window.fayeHandler = new FayeHandler