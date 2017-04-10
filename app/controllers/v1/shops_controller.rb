class V1::ShopsController < V1::BaseController
  def index
    if params[:domain_id]
      shops = ShopDomain.list_shop_domains params[:domain_id]
      result = Shop.list_shops shops.map(&:shop_id)
      if result.present?
        response_success t("api.success"), result
      else
        response_not_found t("api.error_list_shop_by_domain_not_found")
      end
    else
      response_not_found t("api.error_domains_not_found")
    end
  end
end
