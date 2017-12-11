class SendMessageNewProductToChatworkJob < ApplicationJob
  queue_as :default

  def perform product
    SendMessageNewProductToChatworkService.new(product).send unless Settings.weekend.include? Date.today.wday
  end
end
