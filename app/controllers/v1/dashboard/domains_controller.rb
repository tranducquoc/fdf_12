class V1::Dashboard::DomainsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :update
  before_action :load_domain, only: :update

  # Add ID room chatwork to domain
  def update
    if @domain.owner == current_user.id
      if @domain.update_attributes room_chatwork: params[:room_chatwork_id]
        response_success t "api.success"
      else
        response_error t "api.error"
      end
    else
      response_error t "not_have_permission"
    end
  end

  private

  def load_domain
    @domain = Domain.find_by id: params[:id]
    return if @domain.present?
    response_not_found t "api.not_found"
  end
end
