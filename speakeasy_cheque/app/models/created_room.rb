class CreatedRoom
  include Mongoid::Document
  field :sid
  field :room_id
  field :created_at

  def self.create_from_on_tap(data)
    CreatedRoom.create( :sid => data["sid"],
                        :room_id => data["id"],
                        :created_at => data["created_at"] )
  end
end
