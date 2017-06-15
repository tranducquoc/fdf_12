class V1::SearchesController < V1::BaseController
  before_action :load_domain, only: :index

  def index
    products = Product.in_domain(@domain.id).active.search(name_or_description_cont:
      params[:keyword]).result
    shops = Shop.shop_in_domain(@domain.id).search(name_or_description_or_owner_name_cont:
      params[:keyword]).result
    response_success t("api.success"), {products: products, shops: shops}
  end

  private
  def load_domain
    @domain = Domain.find_by id: params[:domain_id]
    unless @domain.present?
      response_not_found t "api.not_found"
    end
  end
end
