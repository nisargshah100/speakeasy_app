class Room < ActiveRecord::Base
  attr_accessible :name, :description, :sid, :github_url
  has_many :messages
  has_many :permissions
  validates_presence_of :name
  validates :name, length: { maximum: 20 }
  after_create :create_room_permission_for_owner

  attr_accessor :username

  def recent_messages
    messages.order(:created_at).reverse_order.limit(50)
  end

  def self.for_user(sid)
    Permission.for_user(sid).map { |permission| permission.room }
  end

  def create_room_permission_for_owner
    Permission.create(sid: sid, room_id: id)
  end
end
