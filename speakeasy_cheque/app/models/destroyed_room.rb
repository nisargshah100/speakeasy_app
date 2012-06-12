class DestroyedRoom
  include Mongoid::Document
  field :sid
  field :room_id
  field :destroyed_at

  def self.create_from_on_tap(data)
    room = DestroyedRoom.new
    room.sid = data["sid"]
    room.room_id = data["id"]
    room.destroyed_at = Time.now.to_s
    room.save
  end
end
