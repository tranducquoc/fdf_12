class SendOrdersInfoToChatworkJob < ApplicationJob
  queue_as :default

  def perform orders
    return if Settings.weekend.include?(Date.today.wday) || !check_shop_settings(orders.first.shop)
    SendOrdersInfoToChatworkService.new(orders).send
  end

  private

  def check_shop_settings shop
    shop.shop_settings[:order_status] != Settings.serialize_false
  end
end
