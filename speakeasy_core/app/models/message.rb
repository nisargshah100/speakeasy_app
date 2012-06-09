class Message < ActiveRecord::Base
  attr_accessible :body, :room_id, :username
  belongs_to :room

  validates_presence_of :body, :room_id, :username
end
