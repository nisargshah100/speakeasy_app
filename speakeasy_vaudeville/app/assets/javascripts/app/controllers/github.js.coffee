$ = jQuery.sub()

class GitHub extends Spine.Controller

  constructor: ->
    @render()

  template: ->
    @events = GitHubEvent.all()
    @view('github/activity')(@)

  render: ->
    $("#github_activity").html @template()

window.GitHub = GitHub