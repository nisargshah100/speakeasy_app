class CreatedPermission
  include Mongoid::Document
  field :sid, type: String
  field :created_at, type: DateTime

  embedded_in :created_room, inverse_of: :created_permissions
  after_create :increment_permissions

  def self.create_from_on_tap(data)
    room = room.find(data["id"])
    room.created_permissions.create(:sid => data["sid"],
                                    :created_at => DateTime.parse(data["created_at"]))
  end

  def increment_permissions
    Aggregate.increment_permissions
  end

end
