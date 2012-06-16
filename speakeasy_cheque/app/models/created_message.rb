require 'chart_series_methods.rb'

class CreatedMessage
  include Mongoid::Document
  extend ChartSeriesMethods

  field :room_id, type: String
  field :sid, type: String
  field :created_at, type: DateTime

  after_create :increment_messages

  def self.create_from_on_tap(data)
    room = CreatedRoom.where(room_id: data["room_id"]).first
    CreatedMessage.create( :room_id => data["room_id"],
                                  :sid => data["sid"],
                                  :created_at => DateTime.parse(data["created_at"]) )
  end

  def increment_messages
    Aggregate.increment_messages
  end
end
