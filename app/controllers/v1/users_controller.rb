class V1::UsersController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :update

  def update
    if current_user.update_attributes info_user_params
      response_success t "api.success"
    else
      response_error t "api.error"
    end
  end

  private
  def info_user_params
    params.require(:user).permit :name, :chatwork_id, :description, :avatar
  end
end
