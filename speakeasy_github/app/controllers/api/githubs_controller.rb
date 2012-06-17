require 'hashie'

class Api::GithubsController < ApplicationController

  def show
    url = params[:url]
    events = []

    if url
      repo = get_repo(url)

      events = Event.joins(:repository).where('repositories.url' => url).reverse.map do |e| 
        EventDecorator.decorate(e) 
      end
    end

    render :json => events
  end

  def create
    data = params["payload"]
    url = JSON.parse(data)["repository"]["url"]
    
    if url
      repo = get_repo(url)
      
      event = Event.create(:repository => repo, :data => data)
      $redis.publish :github_event, EventDecorator.decorate(event).to_json
    end

    render :json => true, :status => 201
  end

  private

  def get_repo(url)
    repo = Repository.where(:url => url).first
    repo ||= Repository.create(:url => url)
  end

end
