class RoomObserver < ActiveRecord::Observer
  def after_create(room)
    SpeakeasyOnTap::publish_created_room(room)
  end

  def after_destroy(room)
    SpeakeasyOnTap::publish_destroyed_room(room)
  end
end
