class V1::AuthenUserTokensController < ApplicationController
  def index
    user = User.find_by_email params[:user_email]
    if user.present?
      if user.valid_password? params[:password]
        user.add_authentication_token
        user.add_device_id params[:device_id]
        serialization = ActiveModelSerializers::SerializableResource.new user
        response_success t("api.success"), serialization
      else
        response_error t "api.error_password_wrong"
      end
    else
      response_not_found t "api.error_user_not_found"
    end
  end  
end
