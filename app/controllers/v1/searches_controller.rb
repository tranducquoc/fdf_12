class V1::SearchesController < V1::BaseController
  before_action :load_domain, only: :index

  def index
    products = Product.by_shop_ids(@domain.shops.map(&:id)).active.search(name_or_description_cont:
      params[:keyword]).result
    result_products = ActiveModel::Serializer::CollectionSerializer.new(products,
        each_serializer: ProductSerializer)
    shops = Shop.shop_in_domain(@domain.id).search(name_or_description_or_owner_name_cont:
      params[:keyword]).result
    result_shops = SearchService.new(shops).include_info_owner
    response_success t("api.success"), {products: result_products, shops: result_shops}
  end

  private
  def load_domain
    @domain = Domain.find_by id: params[:domain_id]
    unless @domain.present?
      response_not_found t "api.not_found"
    end
  end
end
