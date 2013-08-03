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

  def show
    post = Post.published.find_by_id(params[:id])
    post = current_user.posts.find_by_id(params[:id]) if !post && signed_in?
    return _not_found unless post

    respond_with post
  end

  def update
    post = signed_in? ? current_user.posts.find_by_id(params[:id]) : nil
    return _not_found unless post

    post.update_attributes!(post_params)

    # respond_with always returns no content for PATCH/PUT
    render json: post
  end

  def destroy
    post = signed_in? ? current_user.posts.find_by_id(params[:id]) : nil
    return _not_found unless post

    post.destroy!
    respond_with post
  end

  private

  def post_params
    params.require(:post).permit(:subject, :body, :published_at)
  end

  def post_url(post)
    api_post_url(post)
  end
end
