class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_post

  def create
    @report = @post.reports.build load_params
    @report.user_id = current_user.id
    @status = @report.save

    if @report.post.reports.size > Settings.post.max_reports
      @post.update_attributes status: Post.statuses.keys[3]
    end

    respond_to do |format|
      format.html { redirect_to post_path @object }
      format.js
    end
  end

  private
  def load_params
    params.require(:report).permit :content
  end

  def load_post
    @post = Post.find_by id: params[:post_id]
    return if @post.present?
    flash[:danger] = t "ads.post.error.not_found"
    redirect_to domain_ads_posts_path
  end
end
