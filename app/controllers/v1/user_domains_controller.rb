class V1::UserDomainsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    user = User.find_by email: params[:user_email]
    if user.present?
      user_domain = UserDomain.new user_domain_params
      if user_domain.save
        user_domain.create_event_add_user_domain user.id
        response_success t "api.success"
      else
        response_error t "api.error"
      end
    else
      response_error t "api.error_user_not_found"
    end
  end

  private

  def user_domain_params
    params.require(:user_domain).permit(:domain_id, :user_id).merge role: :member
  end
end
