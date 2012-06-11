module AppHelper
  def current_user_name_tag
    tag('meta', name: 'current-user-name', content: current_user.name)
  end

  def current_user_email_tag
    tag('meta', name: 'current-user-email', content: current_user.email)
  end

  def current_sid_tag
    tag('meta', name: 'current-sid', content: current_user.sid)
  end
end
