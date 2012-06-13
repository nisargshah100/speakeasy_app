#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require spine/relation

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

$ = jQuery.sub()

class App extends Spine.Controller
  elements:
    "#messages": "messagesEl"
    ".lobby": "sidebarEl"
    ".invites": "invitesEl"

  constructor: ->
    super
    
    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...
    @sidebar = new Sidebar({el: @sidebarEl})
    @messages = new Messages({el: @messagesEl})
    @inviter = new Inviter({el: @invitesEl})

    # Spine.Route.setup

window.App = App