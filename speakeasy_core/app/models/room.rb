class Room < ActiveRecord::Base
  attr_accessible :name, :description, :sid
  has_many :messages
  has_many :permissions
  validates_presence_of :name

  attr_accessor :username

  def recent_messages
    messages.order(:created_at).reverse_order.limit(50)
  end

  def self.for_user(sid)
    Permission.for_user(sid).map { |permission| permission.room }
  end
end
