class V1::UsersLogoutController < V1::BaseController
  def logout
    user = User.find_by_authentication_token params[:user_token]
    if user.present?
      user.update_attributes device_id: nil
      user.add_authentication_token
      response_success t "api.logout"
    else
      response_unauthorized t "api.error_user_not_found"
    end
  end
end
