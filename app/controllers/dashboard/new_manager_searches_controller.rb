class Dashboard::NewManagerSearchesController < BaseDashboardController
  def index
    @users = User.search(email_or_name_cont: params[:search]).result
  end
end
