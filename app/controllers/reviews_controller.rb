class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_post, :load_review_of_post
  before_action :load_review, only: :update

  def create
    @review = @post.reviews.build review_params
    @review.user_id = current_user.id
    @status = @review.save
    respond_to do |format|
      format.js
    end
  end

  def update
    @review.update_attributes review_params
    manage_likes params[:review][:like]

    @status = @review.save
    respond_to do |format|
      format.js
    end
  end

  private
  def review_params
    params[:score] = params[:score].empty? ? Settings.min_rate_point : params[:score]
    params.require(:review).permit(:review).merge rating: params[:score]
  end

  def load_post
    @post = Post.find_by id: params[:post_id]
    return if @post.present?
    flash[:danger] = t "ads.post.error.not_found"
    redirect_to domain_ads_posts_path
  end

  def load_review
    @review = Review.find_by id: params[:id]
    return if @review.present?
    flash[:danger] = t "ads.post.review.not_found"
    redirect_to domain_ads_posts_path
  end

  def load_review_of_post
    @reviews_of_post = Review.reviews_by_post(@post.class.name, @post.id).newest
  end

  def manage_likes like
    if like == true.to_s && !@review.like_by?(current_user)
      @review.likes.create user_id: current_user.id
    elsif like == false.to_s
      @review.likes.find_by(user_id: current_user.id).destroy
    end
  end
end
