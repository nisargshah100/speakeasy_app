require 'rubygems'
require 'redis'
require 'json'

CHANNELS = ['created_messages', 'created_rooms', 'destroyed_rooms',
            'created_permissions', 'created_users']

redis = Redis.new(:timeout => 0)

redis.subscribe(CHANNELS) do |on|
  on.message do |channel, msg|
    data = JSON.parse(msg)
    puts "##{channel} - [#{data}]"
  end
end
