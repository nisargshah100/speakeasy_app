class RoomObserver < ActiveRecord::Observer
  def after_create(room)
    SpeakeasyOnTap::publish_created_room(room)
  end
end
