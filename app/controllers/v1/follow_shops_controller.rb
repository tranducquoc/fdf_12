class V1::FollowShopsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :update
  before_action :load_shop, only: :update

  def update
    case
    when params[:type] == Settings.type_follow
      current_user.follow @shop
      response_success "api.success"
    when params[:type] == Settings.type_unfollow
      current_user.stop_following @shop
      response_success "api.success"
    else
      response_error t "api.error"
    end
  end

  private

  def load_shop
    @shop = Shop.find_by id: params[:id]
    return if @shop.present?
    response_not_found t "api.not_found"
  end
end
