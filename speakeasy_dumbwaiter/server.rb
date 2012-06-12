require 'drb'
require 'pusher'

Pusher.app_id = ENV['PUSHER_APP_ID']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']

class MessageService
  def self.ping(channel, data, event='speakeasy')
    Pusher[channel].trigger(event, data)
  end

  def self.authenticate(socket_id, channel='who-online', information={})
    Pusher[channel].authenticate(socket_id, information)
  end
end

DRb.start_service "druby://:#{ENV['DRB_PORT']}", MessageService
puts "Server running at #{DRb.uri}"
DRb.thread.join