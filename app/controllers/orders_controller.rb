class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_shop, except: [:edit, :index]
  before_action :load_order, only: [:destroy, :show]
  before_action :load_order_update, only: :update
  before_action :check_before_order, only: :create
  before_action :check_user_status_for_action

  def index
    tmp_orders = current_user.orders
    if params[:start_date].present? && params[:end_date].present?
      if params[:start_date] <= params[:end_date]
        @orders = tmp_orders.between_date convert_date_string(params[:start_date]),
        convert_date_string(params[:end_date])
      else
        flash[:danger] = t "wrong_from_day_to_day_find"
        @orders = tmp_orders.on_today.by_date_newest.page(params[:page])
      end
    else
      @orders = tmp_orders.on_today.by_date_newest.page(params[:page])
    end
    params[:status] ||= Settings.filter_status_order.all
    @orders = @orders.send params[:status]
    @order_days = @orders.group_by{|t| t.created_at.beginning_of_day}
  end

  def new
    @orders = @shop.orders.accepted
    @order = @shop.orders.new
    @cart_shop = load_cart_shop @shop
  end

  def show
  end

  def update
    @cart_shop = load_cart_shop @shop
    if @cart_shop.present?
      if @order.update_attributes order_params @cart_shop
        delete_cart_item_shop @shop
        flash[:success] = t "oder.success"
        redirect_to order_path @order, shop_id: @shop.id
      else
        flash[:danger] = t "oder.not_oder"
        redirect_to new_order_path
      end
    else
      flash[:danger] = t "oder.not_product_in_cart"
      redirect_to carts_path
    end
  end

  def create
    @cart_shop = load_cart_shop @shop
    if @cart_shop.present?
      @order = Order.new params_create_order @cart_shop, @shop
      if @order.save
        delete_cart_item_shop @shop
        check_order @order, @cart_shop, @shop
        @order.create_event_order if checked_notification_setting?(Settings.index_two_in_array)
      else
        flash[:danger] = t "oder.not_oder"
        redirect_to new_order_path
      end
    else
      flash[:danger] = t "oder.not_product_in_cart"
      redirect_to carts_path
    end
  end

  def destroy
    if @order.destroy
      flash[:success] = t "oder.deleted"
    else
      flash[:danger] = t "oder.not_delete"
    end
    redirect_to orders_path
  end

  private

  def order_params cart_shop
    {cart: cart_shop, shop: @shop, user: current_user}
  end

  def load_shop
    @shop = Shop.find_by id: params[:shop_id]
    unless @shop
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to products_path
    end
  end

  def load_order
    @order = Order.find_by id: params[:id]
    unless @order
      flash[:danger] = t "load_order"
      redirect_to products_path
    end
  end

  def load_order_update
    @order = Order.open.find_by id: params[:id]
    unless @order
      flash[:danger] = t "flash.danger.load_order"
      redirect_to new_order_path(shop_id: @shop.id)
    end
  end

  def check_order order, cart_shop, shop
    if order.products.size == Settings.count_tag
      order.destroy
      flash[:danger] = t "oder.allthing_deleted"
      redirect_to :back
    elsif cart_shop.items.size > order.products.size
      flash[:warning] = t "oder.something_deleted"
      redirect_to domain_order_path @domain, @order, shop_id: shop.id
    else
      flash[:success] = t "oder.success"
      redirect_to domain_order_path @domain, order, shop_id: shop.id
    end
  end

  def check_before_order
    @cart_shop = load_cart_shop @shop
    @count_exit_order = Settings.count_tag
    @products_deleted = []
    @order_price = Settings.count_tag
    @cart_shop.items.each do |cart|
      product = Product.find_by id: cart.product_id
      if Time.now.is_between_short_time?(product.start_hour, product.end_hour)
        @count_exit_order += Settings.order_increase
        @products_deleted << product
      else
        @order_price += total_price product.price, cart.quantity
      end
    end
    if @count_exit_order > Settings.count_tag
      if @count_exit_order == @cart_shop.items.size
        @cart_shop.items.each_with_index do |cart, index|
          product = Product.find_by id: cart.product_id
          if product.present? && Time.now.is_between_short_time?(product.start_hour, product.end_hour)
            delete_item = @cart.items.find{|item| item.product_id == product.id.to_s}
            @cart.items.delete delete_item
            @cart_domain.add_cart @cart.sort, session[:domain_id]
            session[:cart_domain] = @cart_domain.update_cart
          end
        end
        redirect_to carts_path
        flash[:danger] = t "oder.allthing_deleted"
      else
        @have_order_deleted = t("oder.has_order_deleted") +
          @count_exit_order.to_s + t("oder.product_deleted")
        redirect_to new_cart_path @have_order_deleted,
          products_deleted: @products_deleted,
          order_price: @order_price, shop_id: @shop.id
      end
    end
  end

  def convert_date_string date
    dates = date.split(Settings.convert_date.seperate);
    return dates[Settings.convert_date.year] + Settings.convert_date.seperate +
      dates[Settings.convert_date.month] + Settings.convert_date.seperate +
      dates[Settings.convert_date.day]
  end
end
