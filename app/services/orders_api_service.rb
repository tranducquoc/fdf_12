class OrdersApiService

  def initialize order_days
    @order_days = order_days
  end

  def result_json
    orders_list = []
    @order_days.sort.each do |day, orders|
      orders.each do |order|
        orders_list << {date: day, order: order}
        order.order_products.each do |product|
          if product.order_id == order.id
            orders_list << {product_of_order: product}
          end
        end
      end
    end
    orders_list
  end
end
