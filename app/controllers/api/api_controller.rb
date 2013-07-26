class Api::ApiController < ApiController
  def index
    respond_with :sessions_url => api_sessions_url
  end
end
