class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def signed_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.find(session[:current_user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
