class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    find_object params[:review][:object_type], parmas[:review][object_id]
    @reviews = @object.reviews.build load_params
  end

  private
  def load_params
    params.require(:review).permit :content
  end

  def find_object type, id
    if type == "Post"
      @object = Post.find_by id: id
    end
  end
end
