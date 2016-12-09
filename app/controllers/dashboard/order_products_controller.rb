class Dashboard::OrderProductsController < BaseDashboardController
  before_action :load_order_item, only: :update
  before_action :load_shop, only: :index

  def index
    @orders = @shop.orders.unfinished.on_today
    updated_orders = @orders.to_a
    @order_products = @shop.order_products.accepted
    if (@order_products.update_all status: :done) &&
      (@orders.update_all status: :done)
      updated_orders.each do |order|
        order.create_event_done
      end
      flash[:success] = t "flash.success.update_order"
      redirect_to dashboard_shop_order_managers_path
    end
  end

  def update
    if @order_product.update_attributes order_product_params
      OrderMailer.shop_confirmation(@order_product).deliver_later
      @order_product.send_notification_order
      flash[:success] = t "flash.success.update_order"
      respond_to do |format|
        format.json do
          render json: {status: @order_product.status}
        end
      end
    else
      render :back
    end
  end

  private

  def order_product_params
    params.require(:order_product).permit :status
  end

  def load_order_item
    @order_product = OrderProduct.find_by id: params[:id]
    unless @order_product
      flash[:danger] = t "flash.danger.load_items"
      redirect_to dashboard_shops_path
    end
  end
end
