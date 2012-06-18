require 'rubygems'
require 'faye'
require 'json'
require 'bundler'
require 'eventmachine'

Bundler.require

# class Connection
#   def self.handle(client, channel, data)
#     puts data
#     self.handleConnectedUser(client, data) if channel == 'connected'
#     self.handleDisconnectedUser(client, data) if channel == 'disconnected'
#   end

#   def self.handleDisconnectedUser(client, data)
#     # puts faye.inspect
#     # faye.publish "/room/#{data['channel']}/left", {}
#   end

#   def self.handleConnectedUser(client, data)
#     client.publish "/room/#{data['channel']}/joined", {
#       :room_id => data['channel'],
#       :username => data['user']['name']
#     }

#     # client.publish "/foo", 'text' => 'nice!'
#   end
# end
EM.run {
  bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
  bayeux.listen(9292)

  client = bayeux.get_client

  def send_to_faye(message)
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def joined_or_left(channel, data)
    data = {
      :room_id => data['channel'],
      :username => data['user']['name']
    }

    message = {
      :channel => "/room/#{data[:room_id]}/#{channel}",
      :data => data
    }

    send_to_faye(message)
  end

  def github_event(data)
    url = data['repository']['url'].gsub(/[^-a-z0-9]/i,'')
    message = {
      :channel => "/github/#{url}",
      :data => data
    }

    puts message.inspect

    send_to_faye(message)
  end

  deferred_listener = Proc.new do
    SpeakeasyOnTap::subscribe_to_channels([:joined, :left, :github_event]) do |channel, data|
      github_event(data) if channel == 'github_event'
      joined_or_left(channel, data) if channel == 'joined' || channel == 'left'
    end
  end

  EM.defer(deferred_listener)
}