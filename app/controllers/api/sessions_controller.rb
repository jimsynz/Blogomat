class Api::SessionsController < ApiController
  skip_before_filter :api_token_authenticate!, only: [:create]

  def create
    token = ApiToken.new(params[:api_token])

    if params[:username]
      @user = User.find_by_username(params[:username])
      token.user = @user if _provided_valid_password? || _provided_valid_api_token?
    end

    respond_with token
  end

  def index
    respond_with current_api_token
  end

  def destroy
    current_api_token.delete!

    render nothing: true, status: 204
  end

  private

  def _provided_valid_password?
    params[:password] && UserAuthenticationService.authenticate_with_password!(@user, params[:password])
  end

  def _provided_valid_api_token?
    params[:api_token] && UserAuthenticationService.authenticate_with_api_key!(@user, params[:api_token])
  end

  def api_token_url(token)
    api_sessions_path(token)
  end
end
