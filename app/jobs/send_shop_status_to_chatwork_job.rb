class SendShopStatusToChatworkJob < ApplicationJob
  queue_as :default

  def perform shop
    SendShopStatusToChatworkService.new(shop).send unless Settings.weekend.include?(Date.today.wday)
  end
end
