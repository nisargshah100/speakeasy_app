class DestroyedRoom
  include Mongoid::Document
  field :sid, type: String
  field :room_id, type: String
  field :destroyed_at, type: DateTime

  after_create :decrement_rooms

  def self.create_from_on_tap(data)
    DestroyedRoom.create( :sid => data["sid"],
                        :room_id => data["id"],
                        :destroyed_at => DateTime.now)
  end

  def decrement_rooms
    Aggregate.decrement_rooms
  end
end
