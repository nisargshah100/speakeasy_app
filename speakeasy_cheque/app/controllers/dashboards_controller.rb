class DashboardsController < ApplicationController
  def show
    @total_users = Aggregate.users
    @total_messages = Aggregate.messages
    @total_rooms = Aggregate.rooms

    @days = Rational(DAY_ZERO - DateTime.now).to_i

    @recent_users = CreatedUser.where(:created_at.gt => DateTime.now - 1).count
    @historical_users = CreatedUser.where(:created_at.lte => DateTime.now - 1).count

    @recent_users_per_day = @recent_users / 2
    @historical_users_per_day = @historical_users / @days

    @all_room_owners_count = CreatedRoom.where(:created_at.lte => DateTime.now).map { |room| room.sid }.uniq.count
    @historical_room_owners_count = CreatedRoom.where(:created_at.lte => DateTime.now - 1).map { |room| room.sid }.uniq.count

    @all_percent_users_creating_room = (@all_room_owners_count.to_f / CreatedUser.count.to_f * 100).round(2)
    @historical_percent_users_creating_room = (@historical_room_owners_count.to_f / @historical_users.to_f * 100).round(2)

    @recent_messages = CreatedMessage.where(:created_at.gt => DateTime.now - 1).count
    @historical_messages = CreatedMessage.where(:created_at.lte => DateTime.now - 1).count

    if params[:num]
      @chart_title = params[:num].titleize
      num_series = params[:num].classify.constantize.series
    else
      @chart_title = "Select a Series"
      num_series = []
    end

    if params[:denom]
      @chart_title = "#{@chart_title} per #{params[:denom].titleize.singularize}"
      denom_series = params[:denom].classify.constantize.series
      denom_series = denom_series.map { |point| point == 0 ? 1 : point }
    else
      denom_series = (1..num_series.length).map { |n| 1 }
    end

    @series = num_series.each_with_index.map { |num, index| (num.to_f/denom_series[index].to_f).round(2) }
    @denom = denom_series
    @num = num_series

    @point_interval, @point_start = TimePeriod.send(params[:x_axis] || "week")
  end
end
