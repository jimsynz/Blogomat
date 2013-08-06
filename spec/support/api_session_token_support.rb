module ApiSessionTokenSupport

  def api_token
    @api_token ||= ApiSessionToken.new
  end

  def sign_in(user)
    api_token.user = user
    request_with_api_token
  end

  def sign_out(user)
    api_token.user = nil
    request_with_api_token
  end

  def request_with_api_token
    request.env['HTTP_AUTHORIZATION'] = api_token.token
  end

  def compute_api_key(username, api_secret, api_token)
    OpenSSL::Digest::SHA256.new("#{username}:#{api_secret}:#{api_token}")
  end
end
