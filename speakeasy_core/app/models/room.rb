class Room < ActiveRecord::Base
  attr_accessible :name, :description, :user_id
  has_many :messages
  validates_presence_of :name
end
