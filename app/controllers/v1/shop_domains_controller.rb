class V1::ShopDomainsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: [:update, :destroy]
  before_action :load_shop_domain, only: [:update, :destroy]

  def index
    domain_id = params[:domain_id]
    if domain_id.present?
      list_shops_by_domain = ShopDomain.all.select do |t|
        t.domain_id.to_s == domain_id
      end
      if list_shops_by_domain.present?
        result = ActiveModelSerializers::SerializableResource.new list_shops_by_domain
        response_success t("api.success"), result
      else
        response_not_found t("api.error_list_shop_by_domain_not_found")
      end
    else
      response_not_found t("api.error_domains_not_found")
    end
  end

  def update
    if ShopDomain.statuses[params[:status]].present?
      result = ShopDomainApiService.new(@shop_domain, current_user,
        params[:status]).change_status
      response result
    else
      response_not_found t "api.status_not_exist"
    end
  end

  def destroy
    result = ShopDomainApiService.new(@shop_domain, current_user, "").destroy_shop_in_domain
    response result
  end

  def show
    if current_user.domains.find_by(id: params[:domain_id]).present?
      list_request = ShopDomain.request_of_domain params[:domain_id]
      list_request.present? ? response_success(t("api.success"), list_request)
      : response_not_found(t "api.requests_not_found")
    else
      response_error t "api.not_owner_domain"
    end
  end

  private
  def load_shop_domain
    @shop_domain = ShopDomain.find_by domain_id: params[:domain_id],
      shop_id: params[:shop_id]
    unless @shop_domain.present?
      response_not_found t "api.not_found"
    end
  end

  def response result
    case result.first
    when Settings.api_type_success
      response_success result.last
    when Settings.api_type_error
      response_error result.last
    when Settings.api_type_not_found
      response_not_found result.last
    end
  end
end
