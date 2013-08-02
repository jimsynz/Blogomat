module UserAuthenticationService
  NotAuthorized = Class.new(Exception)

  module_function

  def authenticate_with_password(user, attempt)
    user && BCrypt::Password.new(user.password) == attempt
  end

  def authenticate_with_password!(user, password)
    authenticate_with_password(user,password) or raise NotAuthorized
  end

  def authenticate_with_api_key(user, key)
    user && OpenSSL::Digest::SHA256.new("#{user.username}:#{user.api_secret}") == key
  end

  def authenticate_with_api_key!(user, key)
    authenticate_with_api_key(user, key) or raise NotAuthorized
  end
end
