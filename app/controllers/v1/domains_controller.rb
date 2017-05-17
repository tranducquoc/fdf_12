class V1::DomainsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: [:create, :update]

  before_action :active_account, only: :create

  def index
    if params[:user_token].present?
      user_domains = UserDomain.all.select do |t|
        t.user_id.to_s == params[:user_id]
      end
      if user_domains.present?
        result = ActiveModel::Serializer::CollectionSerializer.new(user_domains,
          each_serializer: UserDomainSerializer)
        response_success t("api.success"), result
      else
        response_not_found t "api.error_domains_not_found"
      end
    else
      response_not_found t "api.error_user_token_not_found"
    end
  end

  def create
    @domain = Domain.new domain_params
    save_domain = SaveDomainService.new(@domain, current_user).save
    save_domain.first == Settings.api_type_success ? response_success(save_domain.last)
      : response_error(save_domain.last)
  end

  def update
    domain = Domain.find_by id: params[:id]
    if domain.present?
      if Domain.statuses[params[:domain_status]].present?
        domain.status = params[:domain_status]
        domain.save ? response_success(t "api.success" )
          : response_error(t "api.change_status_domain_fail")
      else
        response_error t "api.change_status_domain_fail"
      end
    else
      response_not_found t "api.error_domains_not_found"
    end
  end

  private
  def domain_params
    params.require(:domain).permit(:name, :status).merge! owner: current_user.id
  end

  def active_account
    unless current_user.active?
      response_error = t "information_user_not_active"
    end
  end
end
