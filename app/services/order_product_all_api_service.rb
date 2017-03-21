class OrderProductAllApiService
  def initialize data_carts, count_order, data_orders
    @data_carts = data_carts
    @count_order = count_order
    @data_orders = data_orders
  end

  def order_all_product
    @data_carts.each do |cart|
      @count_order = @count_order + Settings.increase_one
      @data_orders << cart
      order = Order.new cart.permit(:domain_id, :total_pay, :shop_id,
        :user_id, :status, :orders)
      ActiveRecord::Base.transaction do
        order.save
      end
      @data_orders[@count_order]["orders"].each do |product|
        product_order = order.order_products.new product.permit(:status,
          :product_id, :user_id, :quantity)
        ActiveRecord::Base.transaction do
          product_order.save
        end
      end
      event = order.events.new
      event.message = Settings.notification_new
      event.user_id = order.shop.owner_id
      event.eventable_id = order.shop.id
      event.eventitem_id = order.id
      ActiveRecord::Base.transaction do
        event.save
      end
    end
  end
end
