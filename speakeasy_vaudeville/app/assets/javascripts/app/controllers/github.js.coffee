$ = jQuery.sub()

class GitHub extends Spine.Controller

  constructor: ->
    super
    @render()

    GitHubEvent.bind 'create', @addOne
    Room.bind 'joined', @joinedRoom

  joinedRoom: (room_id) =>
    @clear()
    @fetch_all(room_id)

  clear: ->
    $("#github_activity").html('')

  fetch_all: (room_id) ->
    room = Room.find(room_id)
    if room.github_url
      $.get "/api/github?url=#{room.github_url}", (data) =>
        console.log(data)
        for event in data
          GitHubEvent.create(data: event)

        @render()

  addOne: ->


  template: ->
    @events = GitHubEvent.all()
    @view('github/activity')(@)

  render: =>
    @clear()
    $("#github_activity").html @template()
    @scroll()

  scroll: =>
    objDiv = $("#github_activity")[0]
    objDiv.scrollTop = objDiv.scrollHeight

window.GitHub = GitHub