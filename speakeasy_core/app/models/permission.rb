class Permission < ActiveRecord::Base
  attr_accessible :sid, :room_id
  belongs_to :room

  def self.for_user(sid)
    where(sid: sid)
  end
end
