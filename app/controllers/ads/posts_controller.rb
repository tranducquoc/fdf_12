class Ads::PostsController < ApplicationController
  include Ads::PostsHelper
  before_action :authenticate_user!
  before_action :load_post, only: :show

  def index
  end

  def show
    @post_support = Supports::Ads::PostSupport.new @post, current_user
    @review = @post.reviews.build
  end

  def new
    @post = Post.new
    @post.post_images.build
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
      redirect_to domain_ads_post_path(params[:domain_id], @post)
      flash[:success] = t "ads.post.flash.success"
    else
      flash[:danger] = t "ads.post.flash.danger"
      redirect_to new_domain_ads_post_path
    end
  end

  private
  def post_params
    params[:post][:mode] = params[:post][:mode].to_i
    params[:post][:arena] = params[:post][:arena].to_i
    params[:post][:post_images_attributes] =
      rebuild_param params[:post][:post_images_attributes], :image
    params.require(:post).permit :title, :content, :category_id, :mode, :arena,
      :link_shop, post_images_attributes: [:id, :post_id, :image, :_destroy]
  end
  def load_post
    @post = Post.find_by id: params[:id]
    return if @post.present?
    flash[:danger] = t "ads.post.error.not_found"
    redirect_to domain_ads_posts_path
  end
end
