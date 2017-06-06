class V1::ShopsController < V1::BaseController
  before_action :load_domain

  def index
    if params.has_key?(:top_shops)
      top_shops = @domain.shops.top_shops
      if top_shops.present?
        response_success top_shops
      else
        response_not_found t "api.error_list_shop_by_domain_not_found"
      end
    else
      shops = @domain.shops
      if shops.present?
        result = ActiveModel::Serializer::CollectionSerializer.new(shops,
          each_serializer: ShopSerializer)
        response_success t("api.success"), result
      else
        response_not_found t "api.error_list_shop_by_domain_not_found"
      end
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
