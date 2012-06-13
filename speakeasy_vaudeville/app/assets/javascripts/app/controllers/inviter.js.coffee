$ = jQuery.sub()

class Inviter extends Spine.Controller

  elements:
    "input": "input"
    ".invites input#submit": "submit"

  events:
    "click .invites input#submit": "inviteMember"

  constructor: ->
    super
    # console.log @input

  inviteMember: =>
    value = @input.val()
    return false unless value

    $.ajax 
      type: "post"
      url: "/api/core/rooms/#{Sidebar.room().id}/permissions"
      data: { "email": value }
      success: (data) ->
        alert "user added successfully!"
      error: ->
        alert "couldn't find user"

    @input.val ""
    @input.focus()
    false
    
  # render: =>
  #   Message.all()
  #   @items.empty()
  #   Message.each(@addOne)
  #   @scroll()

window.Inviter = Inviter
