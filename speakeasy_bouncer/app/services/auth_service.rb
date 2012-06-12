class AuthService
  def self.authenticate(email, password)
    user = User.authenticate(email, password)
    user ? user.attributes.as_json : nil
  end

  def self.get_user(token)
    user = User.where(:token => token).first
    user ? user.attributes.as_json : nil
  end

  def self.get_user_by_sid(sid)
    user = User.where('sid = ?', sid).first()
    user ? user.attributes.as_json : nil
  end

  def self.get_user_by_email(email)
    user = User.where('email = ?', email).first()
    user ? user.attributes.as_json : nil   
  end

  def self.get_users_by_sid(sids)
    users = sids.map { |sid| AuthService.get_user_by_sid(sid) }
  end
end