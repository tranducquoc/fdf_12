class Admin::PostsController < AdminController
  load_and_authorize_resource

  def index
    if request.xhr?
      @posts = Post.filter(params).page(params[:page])
      respond_to :js
    else
      @post_support = Supports::Admin::PostSupport.new
      @posts = Post.desc.page(params[:page]).per(Settings.admin.post.posts_per_page)
    end
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
    @posts = Post.page(params[:page]).per(Settings.admin.post.posts_per_page)
    respond_to :js
  end
  
end
