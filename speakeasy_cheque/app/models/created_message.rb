class CreatedMessage
  include Mongoid::Document
  field :sid
  field :room_id
  field :created_at

  def self.create_from_on_tap(data)
    CreatedMessage.create(data)
  end
end
