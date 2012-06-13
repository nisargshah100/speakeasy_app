require "speakeasy_on_tap/version"
require "redis"

module SpeakeasyOnTap
  def self.queue
    @queue = Redis.new
  end

  def self.publish_created_message(message)
    queue.publish :created_messages, message.to_json
  end

  def self.publish_created_room(room)
    queue.publish :created_rooms, room.to_json
  end

  def self.publish_destroyed_room(room)
    queue.publish :destroyed_rooms, room.to_json
  end

  def self.publish_created_permission(permission)
    queue.publish :created_permissions, permission.to_json
  end

  def self.subscribe_to_channels(channels, &block)
    queue.subscribe(channels) do |on|
      on.message do |channel, json_data|
        data = JSON.parse(json_data) rescue {}

        if data && !data.keys.empty?
          yield(channel, data)
        end
      end
    end
  end
end
