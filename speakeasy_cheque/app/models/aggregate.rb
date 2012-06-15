class Aggregate
  def self.counter
    $redis
  end

  def self.increment_users
    counter.incr('total_users')
  end

  def self.users
    counter.get('total_users')
  end

  def self.increment_permissions
    counter.incr('total_permissions')
  end

  def self.permissions
    counter.get('total_permissions')
  end

  def self.increment_messages
    counter.incr('total_messages')
  end

  def self.messages
    counter.get('total_messages')
  end

  def self.increment_rooms
    counter.incr('total_rooms')
  end

  def self.decrement_rooms
    counter.decr('total_rooms')
  end

  def self.rooms
    counter.get('total_rooms')
  end
end
