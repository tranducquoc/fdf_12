class Admin::PostsController < AdminController
  load_and_authorize_resource

  def index
    return @posts = Post.all.page(params[:page]).per(Settings.admin.post.posts_per_page) unless request.xhr?
    @posts = Post.search(title_cont: params[:key_search]).result 
    respond_to :js
  end

end
