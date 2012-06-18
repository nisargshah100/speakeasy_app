class Message < ActiveRecord::Base
  attr_accessible :body, :room_id

  belongs_to :room
end
