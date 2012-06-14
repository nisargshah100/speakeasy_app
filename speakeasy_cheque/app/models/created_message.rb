class CreatedMessage
  include Mongoid::Document
  field :sid, type: String
  field :created_at, type: DateTime

  embedded_in :created_room, inverse_of: :created_messages
  after_create :increment_messages

  def self.create_from_on_tap(data)
    room = CreatedRoom.where(room_id: data["room_id"]).first
    room.created_messages.create( :sid => data["sid"],
                                  :created_at => DateTime.parse(data["created_at"]) )
  end

  def increment_messages
    Aggregate.increment_messages
  end
end
