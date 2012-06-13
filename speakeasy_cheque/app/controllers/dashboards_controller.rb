class DashboardsController < ApplicationController
  def show
    @total_messages = CreatedMessage.count
    @total_rooms = CreatedRoom.count - DestroyedRoom.count
  end
end
