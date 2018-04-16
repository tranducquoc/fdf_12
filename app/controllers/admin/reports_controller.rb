class Admin::ReportsController < AdminController
  load_and_authorize_resource

  def index
    @reports = @reports.page(params[:page]).per Settings.common.per_page
  end
end
