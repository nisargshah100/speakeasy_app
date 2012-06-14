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

  deferred_listener = Proc.new do
    SpeakeasyOnTap::subscribe_to_channels([:joined, :left]) do |channel, data|
      data = {
        :room_id => data['channel'],
        :username => data['user']['name']
      }

      message = {
        :channel => "/room/#{data[:room_id]}/#{channel}", 
        :data => data
      }

      puts message.inspect

      uri = URI.parse("http://localhost:9292/faye")
      Net::HTTP.post_form(uri, :message => message.to_json)
    end
  end

  EM.defer(deferred_listener)
}