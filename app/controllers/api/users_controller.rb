class Api::UsersController < ApiController

  def index
    respond_with User.all
  end

  def show
    user = User.find_by_id(params[:id])
    return _not_found unless user
    respond_with user
  end

end
