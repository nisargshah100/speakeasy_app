class MessageObserver < ActiveRecord::Observer
  def after_create(message)
    SpeakeasyOnTap::publish_created_message(message)
  end
end
