class Message < ActiveRecord::Base
  attr_accessible :body, :room_id, :username
  attr_accessor :username
  belongs_to :room

  validates_presence_of :body, :room_id

  def username
    @username
  end

  def username=(value)
    @username = value
  end
end
