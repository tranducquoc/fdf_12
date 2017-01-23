class OrderProductService

  def initialize order_products_pending, updated_orders, shop
    @order_products_pending = order_products_pending
    @updated_orders = updated_orders
    @shop = shop
  end

  def update_order_product
    @order_products_pending.update_all status: :rejected
    @order_products_rejected = @shop.order_products.rejected
    @updated_orders.each do |order|
      done_products = order.order_products.done.size
      rejected_products = order.order_products.rejected.size
      order.create_event_done done_products, rejected_products
    end
  end
end