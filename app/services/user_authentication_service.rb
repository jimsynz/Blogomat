class UserAuthenticationService < Struct.new(:user, :password)
  def self.authenticate(user, password)
    self.new(user, password).authenticate
  end

  def authenticate
    BCrypt::Password.new(user.password) == password
  end
end
