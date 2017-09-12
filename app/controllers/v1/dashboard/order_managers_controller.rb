class V1::Dashboard::OrderManagersController < V1::BaseController
  before_action :check_owner_or_manager, only: :index

  def index
    @order_products_done = OrderProduct.in_date(params[:start_date], params[:end_date])
      .done.history_by_day_with_status(params[:shop_id])
    @order_products_reject = OrderProduct.in_date(params[:start_date], params[:end_date])
      .rejected.history_by_day_with_status(params[:shop_id])
    response_success t("api.success"), ({order_products_done: @order_products_done,
      order_products_reject: @order_products_reject})
  end
end
