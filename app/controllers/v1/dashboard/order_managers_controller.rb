class V1::Dashboard::OrderManagersController < V1::BaseController
  before_action :check_owner_or_manager, only: :index

  def index
    @order_products_done = OrderProduct.history_by_day_with_status(params[:shop_id],
      OrderProduct.statuses[:done])
    @order_products_reject = OrderProduct.history_by_day_with_status(params[:shop_id],
      OrderProduct.statuses[:rejected])
    response_success t("api.success"), ({order_products_done: @order_products_done,
      order_products_reject: @order_products_reject})
  end
end
