class SendShopStatusToChatworkJob < ApplicationJob
  queue_as :default

  def perform shop
    return if Settings.weekend.include?(Date.today.wday) || !check_shop_settings(shop)
    SendShopStatusToChatworkService.new(shop).send
  end

  private

  def check_shop_settings shop
    if shop.status_on_off == Settings.shop_status_off
      shop.shop_settings[:turn_off_shop] == Settings.serialize_true
    else
      shop.shop_settings[:turn_on_shop] != Settings.serialize_false
    end
  end
end
