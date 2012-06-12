class CreatedRoom
  include Mongoid::Document
  field :sid
  field :room_id
  field :created_at

  def self.create_from_on_tap(data)
    room = CreatedRoom.new
    room.sid = data["sid"]
    room.room_id = data["id"]
    room.created_at = data["created_at"]
    room.save
  end
end
