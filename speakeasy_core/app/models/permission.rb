class Permission < ActiveRecord::Base
  attr_accessible :sid, :room_id, :email
  attr_accessor :email
  belongs_to :room
  validates_uniqueness_of :sid, :scope => :room_id

  def self.for_user(sid)
    where(sid: sid)
  end
end
