#= require app

jQuery ->
  $('#log-in-form').submit (e) ->
    e.preventDefault()
    $.ajax
      type: "post"
      url: $(this).attr('action')
      data: $(this).serialize()
      success: (data) ->
        location.href = "/app"
      error: ->
        alert("Invalid Login")