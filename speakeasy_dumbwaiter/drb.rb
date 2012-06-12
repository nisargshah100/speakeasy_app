require 'drb'
require 'faye'

class MessageService
  def self.ping(channel, data, event=nil)
    @faye ||= Faye::Client.new 'http://localhost:9292/faye'
    channel = "#{channel}/#{event}" if event

    puts "Publishing #{data} in #{channel}"
    @faye.publish(channel, data)
  end
end

DRb.start_service "druby://:#{ENV['DRB_PORT']}", MessageService
puts "Server running at #{DRb.uri}"
DRb.thread.join