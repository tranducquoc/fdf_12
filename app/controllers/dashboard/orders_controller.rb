class Dashboard::OrdersController < BaseDashboardController
  before_action :load_shop, except: [:show, :destroy]
  before_action :load_shop_order, only: [:show, :edit]

  def index
    @order = Order.new
    if @shop
      @q = @shop.orders.includes(:user).ransack params[:q]
      @orders = @q.result.by_date_newest
        .page(params[:page]).per Settings.common.per_page
    end
  end

  def edit
  end

  def show
    @order_products = @order.order_products.accepted.group_product
  end

  def update
    if params[:order].present?
      if @shop
        @order = @shop.orders.find_by id: params[:id]
        if @order.update_attributes order_params
          flash[:success] = t "flash.success.update_order"
        else
          render :back
        end
      end
    else
      order = Order.find_by id: params[:id]
      if @shop
        @order = @shop.orders.find_by id: params[:id]
        if @order.update_attributes order_params
          flash[:success] = t "flash.success.update_order"
        else
          render :back
        end
      end
      send_mail_to_user order.order_products
      flash[:success] = t "flash.success.update_order"
      redirect_to edit_dashboard_shop_order_path(@shop.id, order.id)
    end
  end

  def create
    @order = @shop.orders.new order_params_create
    if @order.save
      flash[:success] = t "flash.success.create_order"
      redirect_to dashboard_shop_orders_path
    else
      render :back
    end
  end

  private

  def order_params
    params.require(:order).permit(:status).merge! change_status: true
  end

  def order_params_create
    params.require(:order).permit(:end_at, :notes)
      .merge! user: current_user, change_status: true
  end

  def load_shop
    @shop = Shop.find_by id: params[:shop_id]
    unless @shop
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shops_path
    end
  end

  def load_shop_order
    shop = Shop.find_by id: params[:shop_id]
    if shop
      @order = shop.orders.includes(:products).find_by id: params[:id]
      unless @order
        flash[:danger] = t "flash.danger.load_order"
        redirect_to dashboard_shop_orders_path
      end
    else
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shops_path
    end
  end

  def send_mail_to_user products_order
    products_order.each do |product_order|
      OrderMailer.shop_confirmation(product_order).deliver_later
    end
  end
end
