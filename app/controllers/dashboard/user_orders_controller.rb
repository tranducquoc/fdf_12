class Dashboard::UserOrdersController < BaseDashboardController
  before_action :load_shop, only: :index

  def index
    @order_products_done = OrderProduct.in_date(params[:start_date], params[:end_date])
      .done.order_by_date.group_by_user(@shop.id).group_by{|i| l(i.created_at, format: :custom_date)}
    @order_products_reject = OrderProduct.in_date(params[:start_date], params[:end_date])
      .rejected.order_by_date.group_by_user(@shop.id).group_by{|i| l(i.created_at, format: :custom_date)}
    if request.xhr?
      @params = params
      respond_to do |format|
        format.js
      end
    end
  end
 
  private
  def load_shop
    @shop = Shop.find_by id: params[:shop_id]
    unless @shop
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shop_path
    end
  end
end
