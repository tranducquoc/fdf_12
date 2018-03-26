class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    load_post params[:post_id]
    @reviews = @post.reviews.build load_params
    @reviews.user_id = current_user.id
    load_review_of_post
    @status = @reviews.save
    respond_to do |format|
      format.html { redirect_to post_path @object }
      format.js
    end
  end

  private
  def load_params
    params.require(:review).permit :review
  end

  def load_post post_id
    @post = Post.find_by id: params[:post_id]
    return if @post.present?
    flash[:danger] = t "ads.post.error.not_found"
    redirect_to domain_ads_posts_path
  end

  def load_review_of_post
    @reviews_of_post = Review.reviews_by_post(@post.class.name, @post.id).newest
  end
end
