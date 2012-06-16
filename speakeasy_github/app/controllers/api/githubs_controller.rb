require 'hashie'

class Api::GithubsController < ApplicationController

  def show
    url = params[:url]

    events = Event.where(:repo_url => url).all.map do |e| 
      EventDecorator.decorate(e) 
    end

    # Event.fetch_for(url) if events.length == 0

    render :json => events
  end

  def create
    data = params["payload"]
    url = JSON.parse(data)["repository"]["url"]
    
    event = Event.create(:repo_url => url, :data => data)
    $redis.publish :github_event, EventDecorator.decorate(event).to_json

    render :json => true, :status => 201
  end

end
