class RoomObserver < ActiveRecord::Observer
  def after_create(room)
    SpeakeasyOnTap::publish_room(room)
  end
end
