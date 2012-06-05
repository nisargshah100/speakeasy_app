class Message < ActiveRecord::Base
  attr_accessible :body, :room_id
  belongs_to :room

  validates_presence_of :body, :room_id
end
