class V1::ShopDomainsController < V1::BaseController
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
end
