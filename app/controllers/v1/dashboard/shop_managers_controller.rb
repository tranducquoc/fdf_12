class V1::Dashboard::ShopManagersController < V1::BaseController
  before_action :check_member_of_doamin, only: :index

  def index
    user_ids = UserDomain.users_by_domain(params[:domain_id]).map(&:user_id)
    if user_ids.present?
      result = User.user_of_list_id user_ids
      response_success t("api.success"), result
    else
      response_not_found t "api.not_found"
    end
  end

  private
  def check_member_of_doamin
    user_domain = UserDomain.find_by user_id: current_user.id, domain_id: params[:domain_id]
    unless user_domain.present?
      response_error t "not_have_permission"
    end
  end
end
