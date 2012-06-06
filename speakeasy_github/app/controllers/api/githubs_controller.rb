require 'hashie'

class Api::GithubsController < ApplicationController

  def show
    render :json => Event.all.map { |e| EventDecorator.decorate(e) }
  end

  def create
    data = params["payload"]
    url = JSON.parse(data)["repository"]["url"]
    
    event = Event.create(:repo_url => url, :data => data)
    MESSENGER.ping('github', EventDecorator.decorate(event).to_json)

    render :json => true, :status => 201
  end

end
