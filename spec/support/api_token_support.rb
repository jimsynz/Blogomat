module ApiTokenSupport

  def api_token
    @api_token ||= ApiToken.new
  end

  def sign_in_user(user)
    api_token.user = user
  end

  def sign_out_user(user)
    api_token.user = nil
  end

  def request_with_api_token
    request.env['HTTP_AUTHORIZATION'] = api_token.token
  end
end
