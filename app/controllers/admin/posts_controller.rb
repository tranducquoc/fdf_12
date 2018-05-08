class Admin::PostsController < AdminController
  load_and_authorize_resource

  def index
    @posts = Post.all.page(params[:page]).per Settings.admin.post.posts_per_page
  end
end
