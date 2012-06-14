class DashboardsController < ApplicationController
  def show
    @total_users = CreatedUser.count
    @total_messages = CreatedMessage.count
    @total_rooms = CreatedRoom.count - DestroyedRoom.count
  end
end
