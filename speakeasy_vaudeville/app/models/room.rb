class Room < ActiveRecord::Base
  attr_accessible :description, :name, :user_id
  has_many :messages
end
