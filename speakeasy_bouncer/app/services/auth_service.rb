class AuthService
  def self.authenticate(email, password)
    user = User.authenticate(email, password)
  end

  def self.get_user(token=nil)
    user = User.where(:token => token).first
  end
end