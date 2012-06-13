class CreatedMessage
  include Mongoid::Document
  field :sid
  field :room_id
  field :created_at

  def self.create_from_on_tap(data)
    message = CreatedMessage.new
    message.sid = data["sid"]
    message.room_id = data["room_id"]
    message.created_at = data["created_at"]
    message.save
  end
end
