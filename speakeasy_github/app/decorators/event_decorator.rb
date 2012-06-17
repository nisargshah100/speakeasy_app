class EventDecorator < Draper::Base
  decorates :event

  def as_json(*params)
    repository = model.data['repository']
    head_commit = model.data['head_commit'] || {}
    committer = head_commit['committer'] || {}
    pusher = model.data['pusher'] || {
      :username => committer['login'],
      :email => head_commit['commit']['author']['email']
    }
    pusher[:username] ||= pusher[:name] || pusher['name']

    resp = {
      :pusher => pusher,
      :repository => repository.as_json(:only => [:url]),
      :commit => {
        :message => head_commit['message'] || head_commit['commit']['message'],
        :url => head_commit['url']
      }
    }
  end
end
