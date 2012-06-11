$redis ||= Redis.new(:host => 'localhost', :port => 6379)

class MessageObserver < ActiveRecord::Observer
  def after_create(rec)
    $redis.publish(:messages, rec.to_json)
  end
end
