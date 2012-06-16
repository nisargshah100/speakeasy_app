$ = jQuery

class FayeHandler extends Spine.Module

  constructor: (@url=FayeHandler.url) ->
    @faye ||= new Faye.Client(@url)
    @connected ||= {}

    Room.bind 'refresh', @subscribeToRooms
    Sidebar.bind 'joinedRoom', @joinGitHub

    # @publishJoinedRoom()
    # @publishLeftRoom()

  @url:
    "#{window.location.host.replace(':9000', '').replace(':9001', '')}:9292/faye"

  publishToRoom: (room, msg) =>
    @faye.publish "/room/#{room.id}", msg

  # publishJoinedRoom: =>
  #   console.log('Publsih Joined Room Entered')
  #   Sidebar.bind 'joinedRoom', (room_id) =>
  #     @faye.publish "/room/#{room_id}/joined", { 
  #       username: $("meta[name=current-user-name]").attr("content"), 
  #       room_id: room_id 
  #     }

  # publishLeftRoom: =>
  #   Sidebar.bind 'leftRoom', (room_id) =>
  #     @faye.publish "/room/#{room_id}/left", { 
  #       username: $("meta[name=current-user-name]").attr("content"), 
  #       room_id: room_id
  #     }

  subscribeToRoom: (room) =>
    if not @connected[room.id]
      console.log('subscribed')
      @faye.subscribe "/room/#{room.id}/joined", (msg) =>
        if Search.isSearch == false
          Spine.Ajax.disable =>
            @joinedRoom(msg)

      @faye.subscribe "/room/#{room.id}/left", (msg) =>
        if Search.isSearch == false
          Spine.Ajax.disable =>
            @leftRoom(msg)

      @faye.subscribe "/room/#{room.id}", (msg) =>
        if Search.isSearch == false
          Spine.Ajax.disable =>
            msg = Message.create(
              body: msg.body,
              room_id: msg.room_id,
              username: msg.username,
              sid: msg.sid
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

  joinGitHub: (room_id) =>
    GitHubEvent.deleteAll()
    room = Room.find(room_id)
    @subscribeToGitHub(room.github_url) if room?.github_url

  subscribeToGitHub: (url) =>
    faye_url = "/github/#{url.replace(/[^-a-z0-9]/ig,'')}"
    if not @connected[faye_url]
      @faye.subscribe faye_url, (msg) =>
        if Sidebar.room().github_url == msg.repository.url
          GitHubEvent.create(url: url, data: msg)
      @connected[faye_url] = true

$ -> 
  window.fayeHandler = new FayeHandler