class CreatedPermission
  include Mongoid::Document
  field :sid
  field :room_id
  field :created_at

  def self.create_from_on_tap(data)
    permission = CreatedPermission.new
    permission.sid = data["sid"]
    permission.room_id = data["room_id"]
    permission.created_at = data["created_at"]
    permission.save
  end

end