class Ads::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_post, only: :show

  def index
    @post_support = Supports::Ads::PostSupport.new nil, nil, params
  end

  def show
    @post_support = Supports::Ads::PostSupport.new @post, current_user
    @review = @post.reviews.build
  end

  def new
    @post = Post.new
    @post.images.build
    @parent_categories = Category.is_parent
    @children_categories = Category.by_parent @parent_categories.first.id
    if request.xhr?
      @children_categories = Category.by_parent params[:category_id]
      render json: {children_categories: @children_categories}
    end
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:success] = t "ads.post.flash.success"
      respond_to do |format|
        format.js {render locals: {redirect_url: domain_ads_post_path(params[:domain_id], @post)}}
      end
    else
      flash[:danger] = t "ads.post.flash.danger"
      respond_to do |format|
        format.js {render locals: {redirect_url: new_domain_ads_post_path}}
      end
    end
  end

  private
  def post_params
    params.require(:post).permit :title, :content, :category_id, :mode, :arena,
      :link_shop, :min_price, :max_price, images_attributes: [:image, :_destroy]
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post.present?
    flash[:danger] = t "ads.post.error.not_found"
    redirect_to domain_ads_posts_path
  end
end
