#= require app

jQuery ->
  $('#log-in-form').submit (e) ->
    e.preventDefault()
    $.ajax
      type: "post"
      url: $(this).attr('action')
      data: $(this).serialize()
      success: (data) ->
        location.href = "/"
      error: ->
        alert("Invalid Login")

  $('#sign-up-form').submit (e) ->
    $('p.validation').remove();
    e.preventDefault() # removing throws error but redirects
    $.ajax
      type: "post"
      url: $(this).attr('action')
      data: $(this).serialize()
      success: (data) ->
        location.href = "/app"
      error: (data) ->
        validation = JSON.parse(data.responseText)
        $('#user_email').after("<p class='validation'>email " + (validation.email[0]) + "</p>") if validation.email?
        $('#user_name').after("<p  class='validation'>name " + (validation.name[0]) + "</p>") if validation.name?
        $('#user_password').after("<p  class='validation'>password " + (validation.password[0]) + "</p>") if validation.password?