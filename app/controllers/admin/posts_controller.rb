class Admin::PostsController < AdminController
  load_and_authorize_resource

  def index
    return @posts = Post.page(params[:page]).per(Settings.admin.post.posts_per_page) unless request.xhr?
    @posts = Post.search(title_cont: params[:key_search]).result
    respond_to :js
  end

  def update
    if params[:approve_flag].present?
      @post.approved!
    elsif params[:reject_flag].present?
      @post.rejected!
    else
      flash[:error] = t ".approve_reject_error"
      redirect_to admin_post_path
    end
    @posts = Post.page(params[:page])
    respond_to :js
  end
end
