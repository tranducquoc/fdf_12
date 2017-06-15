class OrderProductAllApiService
  def initialize data_carts, user
    @data_carts = data_carts
    @current_user = user
  end

  def order_all_product
    @data_carts.each do |cart|
      ActiveRecord::Base.transaction do
        begin
          order = Order.new cart.permit(:domain_id, :total_pay, :shop_id, :user_id)
          order.save
          cart["products"].each do |product|
            product_order = order.order_products.new product.permit(:product_id,
              :quantity, :notes).merge! user_id: cart[:user_id]
            product_order.save
          end
          order.create_event_order if checked_notification_setting?(Settings.index_two_in_array)
        rescue
          return false
        end
      end
    end
    return true
  end

  private
  def checked_notification_setting? index
    if @current_user.notification_settings.present?
      case @current_user.notification_settings.values[index]
      when Settings.serialize_false
        return false
      when Settings.serialize_true
        return true
      end
    else
      return true
    end
  end
end
