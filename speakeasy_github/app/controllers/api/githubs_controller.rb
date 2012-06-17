require 'hashie'

class Api::GithubsController < ApplicationController

  def show
    url = params[:url]
    events = []

    if url
      repo = Repository.first_or_create(:url => url)

      events = Event.joins(:repository).where('repositories.url' => url).reverse.map do |e| 
        EventDecorator.decorate(e) 
      end
    end

    render :json => events
  end

  def create
    data = params["payload"]
    url = JSON.parse(data)["repository"]["url"]
    
    repo = Repository.first_or_create(:url => url)
    event = Event.create(:repository => repo, :data => data)
    $redis.publish :github_event, EventDecorator.decorate(event).to_json

    render :json => true, :status => 201
  end

end
