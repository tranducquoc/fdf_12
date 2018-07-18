class Admin::NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "admin_notification_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
