class Admin::ReportsController < AdminController
  load_and_authorize_resource

  def index
    @reports = @reports.page(params[:page]).per Settings.common.per_page
  end

  def update
    @report.post.update_attributes post_params
    @reports = Report.all.page(params[:page]).per Settings.common.per_page
    respond_to :js
  end

  private

  def post_params
    params.require(:post).permit :status
  end
end
