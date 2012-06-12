$ = jQuery

class FayeHandler extends Spine.Module

  constructor: (@url='http://localhost:9292/faye') ->
    @faye ||= new Faye.Client(@url)
    Room.bind 'refresh', @subscribeToRooms

  publishToRoom: (room, msg) =>
    @faye.publish "/room/#{room.id}", msg

  publishJoinedRoom: (room) =>
    @faye.publish "/room/#{room.id}/joined", { 
      username: $("meta[name=current-user-name]").attr("content"), 
      room_id: room.id 
    }

  publishLeftRoom: (room) =>
    @faye.publish "/room/#{room.id}/left", { 
      username: $("meta[name=current-user-name]").attr("content"), 
      room_id: room.id 
    }

  subscribeToRoom: (room) =>
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

  subscribeToRooms: =>
    @rooms = Room.all()
    for room in @rooms
      @subscribeToRoom(room)

  joinedRoom: (msg) =>
    msg = Message.create(
      body: "#{msg?.username || 'Anonymous'} just joined"
      room_id: msg?.room_id || -1
      plain: true
    )

  leftRoom: (msg) =>
    msg = Message.create(
      body: "#{msg?.username || 'Anonymous'} just left"
      room_id: msg?.room_id || -1
      plain: true
    )

$ -> 
  window.fayeHandler = new FayeHandler