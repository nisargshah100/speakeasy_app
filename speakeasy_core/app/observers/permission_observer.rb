class PermissionObserver < ActiveRecord::Observer
  def after_create(permission)
    SpeakeasyOnTap::publish_created_permission(permission)
  end
end