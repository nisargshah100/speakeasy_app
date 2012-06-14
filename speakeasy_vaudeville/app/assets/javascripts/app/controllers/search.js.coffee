$ = jQuery.sub()

class Search extends Spine.Controller

  @isSearch = false

  @resetSearch: ->
    if Search.isSearch == true
      Search.isSearch = false
      $("#search_box").val('')
      Message.fetch()

  constructor: ->
    $("#search_form").live('submit', @searchSubmit)
    Sidebar.bind 'joinedRoom', Search.resetSearch

    @render()

  template: ->
    @view('rooms/search')()

  searchSubmit: (e) =>
    e.preventDefault()
    @search($("#search_box").val())

  search: (q) ->
    console.log(q == '')
    if q == null || q == ''
      Search.isSearch = false
      Message.deleteAll()
      Message.fetch()
      return

    Search.isSearch = true
    $.get '/api/search/', { query: q, ns: "[room]#{Sidebar.room().id}" }, (data) =>
      if data.length > 0
        Message.deleteAll()

        for message in data
          Spine.Ajax.disable =>
            Message.create(
              body: message.body
              username: message.username
              room_id: message.room_id
            )

        Message.trigger 'refresh'
      else
        alert 'No messages found'

  render: =>
    $("#room_search").html @template()

window.Search = Search