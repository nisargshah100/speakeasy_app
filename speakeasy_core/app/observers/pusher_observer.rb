class PusherObserver < ActiveRecord::Observer
  observe :message

  def after_create(rec)
    publish(:create, rec)
  end
  
  # def after_update(rec)
  #   publish(:update, rec)
  # end
  
  # def after_destroy(rec)
  #   publish(:destroy, rec)
  # end
  
  protected

  def publish(type, rec)
    attrs = rec.attributes
    user = AuthService.get_user_by_sid(rec.sid)
    attrs['username'] = user['name'] if user

    Messenger.ping(rec.room_id.to_s, {
      id:   rec.id,
      class:  rec.class.name,
      record: attrs,
    }.to_json, 'create')
  end
end
