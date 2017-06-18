module Dashboard::ShopsHelper
  def orders_pending_of_shop shop
    shop.orders.pending.size
  end
end
