class EventDecorator < Draper::Base
  decorates :event

  def as_json(*params)
    pusher = model.data['pusher']
    repository = model.data['repository']
    head_commit = model.data['head_commit'] || {}
    committer = head_commit['committer'] || {}

    resp = {
      :pusher => pusher,
      :repository => repository.as_json(:only => [:name, :url]),
      :commit => {
        :username => committer['username'],
        :message => head_commit['message'],
        :url => head_commit['url'],
        :timestamp => head_commit['timestamp']
      }
    }
  end
end
