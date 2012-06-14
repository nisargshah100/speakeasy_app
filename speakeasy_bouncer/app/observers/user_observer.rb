class UserObserver < ActiveRecord::Observer
  def after_create(user)
    SpeakeasyOnTap::publish_created_user(user)
  end
end
