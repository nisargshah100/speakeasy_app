class DashboardsController < ApplicationController
  def show
    @total_users = Aggregate.users
    @total_messages = Aggregate.messages
    @total_rooms = Aggregate.rooms

    @days = Rational(DAY_ZERO - DateTime.now).to_i

    @recent_users = CreatedUser.where(:created_at.gt => DateTime.now - 2).count
    @historical_users = CreatedUser.where(:created_at.lte => DateTime.now - 2).count

    @recent_users_per_day = @recent_users / 2
    @historical_users_per_day = @historical_users / @days

    @all_room_owners_count = CreatedRoom.where(:created_at.lte => DateTime.now).map { |room| room.sid }.uniq.count
    @historical_room_owners_count = CreatedRoom.where(:created_at.lte => DateTime.now - 2).map { |room| room.sid }.uniq.count

    @all_percent_users_creating_room = (@all_room_owners_count.to_f / CreatedUser.count.to_f * 100).round(2)
    @historical_percent_users_creating_room = (@historical_room_owners_count.to_f / @historical_users.to_f * 100).round(2)
  end
end
