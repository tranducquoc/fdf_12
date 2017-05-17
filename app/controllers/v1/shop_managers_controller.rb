class V1::ShopManagersController < V1::BaseController

  def index
    shop = Shop.find_by id: params[:shop_id]
    if shop.present?
      user_managers = shop.shop_managers.select_user_add_role
      if user_managers.detect {|u| u.id == current_user.id}.present?
        response_success t("api.success"), user_managers
      else
        response_error t "api.error"
      end
    else
      response_not_found "shop_not_found"
    end
  end
end
