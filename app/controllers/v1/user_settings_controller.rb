class V1::UserSettingsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :update

  def update
    if current_user.update_attributes setting_params
      response_success t "api.success"
    else
      response_error t "api.error"
    end
  end

  private
  def setting_params
    params.require(:user).permit notification_settings: [:order_request,
      :order_processed, :send_order],
      email_settings: [:order_request, :order_processed, :send_order],
      chatwork_settings: [:chatwork_processed, :shop_open]
  end
end
