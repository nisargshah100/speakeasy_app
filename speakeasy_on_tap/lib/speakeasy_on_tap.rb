require "speakeasy_on_tap/version"
require "redis"

module SpeakeasyOnTap
  $redis = Redis.new

  def self.publish_created_message(message)
    $redis.publish :created_messages, message.to_json
  end

  def self.publish_created_room(room)
    $redis.publish :created_rooms, room.to_json
  end

  def self.publish_destroyed_room(room)
    $redis.publish :destroyed_rooms, room.to_json
  end

  def self.publish_created_permission(permission)
    $redis.publish :created_permissions, permission.to_json
  end

  def self.subscribe_to_channels(channels, &block)
    $redis.subscribe(channels) do |on|
      on.message do |channel, json_data|
        data = JSON.parse(json_data) rescue {}

        if data && !data.keys.empty?
          yield(channel, data)
        end
      end
    end
  end
end
