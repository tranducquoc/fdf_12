class V1::UserSettingsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :update

  def update
    if current_user.update_attributes setting_params
      response_success t "api.success"
    else
      response_error t "api.error"
    end
  end

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
    chatwork_settings = current_user.chatwork_settings
    if chatwork_settings.present?
      user_settings << chatwork_settings
    else
      user_settings << {chatwork_processed: Settings.serialize_true,
        shop_open: Settings.serialize_true}
    end
    response_success t("api.success"), user_settings
  end

  private
  def setting_params
    params.require(:user).permit notification_settings: [:order_request,
      :order_processed, :send_order],
      email_settings: [:order_request, :order_processed, :send_order],
      chatwork_settings: [:chatwork_processed, :shop_open]
  end
end
