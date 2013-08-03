class Api::SessionsController < ApiController
  skip_before_filter :api_token_authenticate!, only: [:create]

  def create
    token = current_api_token

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
    params[:api_key] && UserAuthenticationService.authenticate_with_api_key!(@user, params[:api_key], current_api_token.token)
  end

  def api_token_url(token)
    api_sessions_path(token)
  end
end
