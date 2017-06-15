class V1::UserSettingsController < V1::BaseController
  def index
    user_settings = []
    email_settings = current_user.email_settings
    if email_settings.present?
      user_settings << email_settings
    else
      user_settings << {order_request: Settings.serialize_true,
        order_processed: Settings.serialize_true, send_order: Settings.serialize_true}
    end
    notification_settings = current_user.notification_settings
    if notification_settings.present?
      user_settings << notification_settings
    else
      user_settings << {order_request: Settings.serialize_true,
        order_processed: Settings.serialize_true, send_order: Settings.serialize_true}
    end
    response_success t("api.success"), user_settings
  end
end
