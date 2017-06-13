class V1::Dashboard::ShopDomainsController < V1::BaseController
  before_action :load_domain, only: :index

  def index
    shops = @domain.shops
    if shops.present?
      result = []
      shops.each do |s|
        shop_hash = s.attributes.slice("id", "name", "description", "status",
          "avatar", "averate_rating", "owner_id")
        shop_hash["owner_name"] = s.owner_name
        shop_hash["owner_email"] = s.owner_email
        shop_hash["owner_avatar"] = s.owner_avatar
        shop_managers = s.shop_managers
        shop_manager_array = []
        shop_managers.each do |sm|
          shop_manager_hash = sm.attributes.slice("id", "user_id", "shop_id", "role")
          shop_manager_hash["user_name"] = sm.user_name
          shop_manager_array << shop_manager_hash
        end
        shop_hash["shop_managers"] = shop_manager_array
        shop_hash["total_products"] = s.products.size
        result << shop_hash
      end
      response_success t("api.success"), result
    else
      response_not_found t "api.error_list_shop_by_domain_not_found"
    end
  end

  private
  def load_domain
    @domain = Domain.find_by id: params[:domain_id]
    unless @domain.present?
      response_not_found t "api.error_domains_not_found"
    end
  end
end
