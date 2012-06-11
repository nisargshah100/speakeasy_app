require "speakeasy_on_tap/version"
require "redis"

module SpeakeasyOnTap
  $redis = Redis.new

  def self.publish_message(message)
    $redis.publish :messages, message.to_json
  end
end
