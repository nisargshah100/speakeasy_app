class CreatedPermission
  include Mongoid::Document
  field :sid, type: String
  field :room_id, type: String
  field :created_at, type: DateTime

  def self.create_from_on_tap(data)
    CreatedPermission.create(:sid => data["sid"],
                            :room_id => data["room_id"],
                            :created_at => DateTime.parse(data["created_at"]))
  end

end
