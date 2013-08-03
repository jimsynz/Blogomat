module UserAuthenticationService
  NotAuthorized = Class.new(Exception)

  module_function

  def authenticate_with_password(user, attempt)
    user && BCrypt::Password.new(user.password) == attempt
  end

  def authenticate_with_password!(user, password)
    authenticate_with_password(user, password) or raise NotAuthorized
  end

  # FIXME
  # I'm not entirely happy with this solution, as this means that the api key
  # will always be exactly the same, making it super simple to MITM.
  # Suggestions on how to improve it?  Perhaps include a timestamp or something
  # else that the API client and the server know, but not a third party?
  def authenticate_with_api_key(user, key)
    user && OpenSSL::Digest::SHA256.new("#{user.username}:#{user.api_secret}") == key
  end

  def authenticate_with_api_key!(user, key)
    authenticate_with_api_key(user, key) or raise NotAuthorized
  end
end
