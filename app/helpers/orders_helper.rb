module OrdersHelper
  def shop_domain_select shop
    shop.domains.map{|domain| [domain.name, domain.id]}
  end

  def user_name_for_id id
    user = User.find_by id: id
    user.name if user
  end

  def order_manage_filter
    {I18n.t("order_manage_filter.product") => "product",
      I18n.t("order_manage_filter.user") => "user"}
  end

  def sum_price orders
    orders.sum{|order| total_price(order.product_price, order.quantity)}
  end

  def group_by_user orders
    orders.group_by{|u| u.user_id}
  end
end
