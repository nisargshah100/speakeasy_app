require 'chart_series_methods.rb'

class CreatedPermission
  include Mongoid::Document
  extend ChartSeriesMethods

  field :room_id, type: String
  field :sid, type: String
  field :created_at, type: DateTime

  after_create :increment_permissions

  def self.create_from_on_tap(data)
    CreatedPermission.create(:room_id => data["room_id"],
                             :sid => data["sid"],
                             :created_at => DateTime.parse(data["created_at"]))
  end

  def increment_permissions
    Aggregate.increment_permissions
  end

end
