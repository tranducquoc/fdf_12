class SendShopStatusToChatworkJob < ApplicationJob
  queue_as :default

  def perform shop
    return if Settings.weekend.include?(Date.today.wday) || shop.status_on_off == Settings.shop_status_off
    SendShopStatusToChatworkService.new(shop).send
  end
end
