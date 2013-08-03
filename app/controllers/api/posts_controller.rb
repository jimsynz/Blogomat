class Api::PostsController < ApiController
  def create
    return _not_authorized unless signed_in?
    respond_with current_user.posts.create(post_params)
  end

  def index
    respond_with Post.published.
      in_reverse_chronological_order.
      paginate(params[:page_number], params[:per_page] || 20)
  end

  private

  def post_params
    params.require(:post).permit(:subject, :body, :published_at)
  end

  def post_url(post)
    api_post_url(post)
  end
end
