class Api::SessionsController < ApiController

  def create
    user = User.find_by_username(params[:username])

    return _not_authorized unless _user_is_authentic? user

    _sign_in user
    respond_with user
  end

  def index
    return _not_authorized unless signed_in?
    respond_with current_user
  end

  def destroy
    _sign_out
    render json: { ok: :ok }
  end

  private

  def user_url(*args)
    api_users_url(*args)
  end

  def _not_authorized
    render json: { error: 'not authorized' }, status: 401
  end

  def _user_is_authentic? user
    user && UserAuthenticationService.authenticate(user, params[:password])
  end

  def _sign_in user
    session[:current_user_id] = user.id
  end

  def _sign_out
    session.delete(:current_user_id)
  end
end
