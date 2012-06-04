#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

$ = jQuery.sub()

class App extends Spine.Controller
  elements:
    "#messages": "messagesEl"
    "#sidebar": "sidebarEl"

  constructor: ->
    super
    
    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...
    @messages = new Messages({el: @messagesEl})
    @sidebar = new Sidebar({el: @sidebarEl})

    # Spine.Route.setup

window.App = App