class V1::Dashboard::OrderProductsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :update
  before_action :check_owner_or_manager, only: :update
  before_action :check_status, only: :update

  def update
    case
    when params[:order_id].present?
      update_one_order
    when params[:order_product_id].present?
      update_all_orders
    else
      update_order_product
    end
  end

  private
  def check_status
    unless params[:status].present? && (params[:status] ==
      Settings.filter_status_order.accepted || params[:status] ==
      Settings.filter_status_order.rejected)
      response_not_found t "api.status_not_exist"
    end
  end

  def check_order order
    order.pending? && order.shop_id == params[:shop_id].to_i
  end

  def update_one_order
    order = Order.find_by id: params[:order_id]
    if order.present? && check_order(order)
      response_to_client order.order_products.update_all status: params[:status]
    else
      response_not_found t "api.not_found"
    end
  end

  def update_all_orders
    order_product = OrderProduct.find_by id: params[:order_product_id]
    if order_product.present? && check_order(order_product.order)
      response_to_client order_product.update_attribute :status, params[:status]
    else
      response_not_found t "api.not_found"
    end
  end

  def update_order_product
    list_orders_id = Order.orders_of_shop_pending(params[:shop_id]).ids
    order_products = OrderProduct.all_order_product_of_list_orders list_orders_id
    if order_products
      response_to_client order_products.update_all status: params[:status]
    else
      response_not_found t "api.not_found"
    end
  end

  def response_to_client condition
    if condition
      response_success t "api.success"
    else
      response_error t "api.error"
    end
  end
end
