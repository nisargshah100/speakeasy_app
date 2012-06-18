class Message < ActiveRecord::Base
  attr_accessible :body, :room_id, :sid, :username
  attr_accessor :username
  belongs_to :room

  validates_presence_of :body, :room_id


  def username
    @username
  end

  def username=(value)
    @username = value
  end

  def as_json(*params)
    {
      :body => self.body,
      :room_id => self.room_id,
      :sid => self.sid,
      :username => self.username,
      :id => self.id,
      :created_at => self.created_at
    }
  end
end
