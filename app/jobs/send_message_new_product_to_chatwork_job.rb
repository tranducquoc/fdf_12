class SendMessageNewProductToChatworkJob < ApplicationJob
  queue_as :default

  def perform product
    return if Settings.weekend.include?(Date.today.wday) || !check_shop_settings(product.shop)
    SendMessageNewProductToChatworkService.new(product).send
  end

  private

  def check_shop_settings shop
    shop.shop_settings[:new_product] == Settings.serialize_true
  end
end
