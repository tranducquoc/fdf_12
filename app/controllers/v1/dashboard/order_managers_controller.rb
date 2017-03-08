class V1::Dashboard::OrderManagersController < V1::BaseController

  def index
    @user = User.find_by id: params[:user_id]
    if Shop.exists? params[:shop_id]
      @shop = Shop.find params[:shop_id]
      unless @shop.is_owner? @user
        response_not_found t "flash.danger.load_shop"
      end
    else
      response_not_found t "flash.danger.load_shop"
    end
    @order_products_done = OrderProduct.history_by_day_with_status(@shop.id,
      OrderProduct.statuses[:done]).group_by_products_by_created_at
    @order_products_reject = OrderProduct.history_by_day_with_status(@shop.id,
      OrderProduct.statuses[:rejected]).group_by_products_by_created_at
    response_success t("api.success"), ({order_products_done: @order_products_done,
      order_products_reject: @order_products_reject})
  end
end
