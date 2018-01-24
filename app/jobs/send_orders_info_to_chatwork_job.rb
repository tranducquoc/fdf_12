class SendOrdersInfoToChatworkJob < ApplicationJob
  queue_as :default

  def perform orders
    SendOrdersInfoToChatworkService.new(orders).send unless Settings.weekend.include?(Date.today.wday)
  end
end
