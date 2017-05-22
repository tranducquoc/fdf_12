class V1::CommentsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: [:create, :destroy]
  before_action :load_commentable_object, only: [:create, :index]
  before_action :load_comment, only: :destroy

  def create
    @comment = @commentable.comments.build comment_params
    if @comment.content.length < Settings.min_content_of_comment ||
      @comment.content.length > Settings.max_content_of_comment
      response_error t("comment_short_or_long", min: Settings.min_content_of_comment,
        max: Settings.max_content_of_comment)
    else
      if @comment.save
        response_success t "flash.success_message"
      else
        response_error t "flash.danger_message"
      end
    end
  end

  def index
    comments = @commentable.comments.add_name_image_of_user
    response_success t("api.success"), comments
  end

  def destroy
    if @comment.destroy
      response_success t "flash.success_message"
    else
      response_error t "flash.danger_message"
    end
  end

  private
  def load_comment
    @comment =  Comment.find_by id: params[:id]
    unless @comment
      response_error t "flash.danger_message"
    end
  end

  def comment_params
    params.require(:comment).permit(:content).merge! user_id: current_user.id
  end

  def load_commentable_object
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return @commentable = $1.classify.constantize.find(value)
      end
    end
    response_error t "flash.danger_message"
  end
end
