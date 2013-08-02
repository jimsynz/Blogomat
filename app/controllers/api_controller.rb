class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json
  rescue_from UserAuthenticationService::NotAuthorized, with: :_not_authorized
  before_filter :api_token_authenticate!

  private

  def api_token_authenticate!
    return _not_authorized unless _authorization_header && current_api_token.valid?
  end

  def current_api_token
    @current_api_token ||= ApiToken.new(_authorization_header)
  end

  def _authorization_header
    request.headers['HTTP_AUTHORIZATION']
  end

  def _not_authorized message = "Not Authorized"
    render json: { error: message }, status: 401
  end
end
