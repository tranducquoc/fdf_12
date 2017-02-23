class V1::ProductsController < V1::BaseController
  def index
    if params[:category_id].present?
      products = Product.all.select do |t|
        (t.category_id.to_s == params[:category_id] &&
          t.product_domains.find_by_domain_id(params[:domain_id]))
      end
    else
      products = Product.all.select do |t|
        t.product_domains.find_by_domain_id(params[:domain_id])
      end
    end
    if products.present?
      result = ActiveModel::Serializer::CollectionSerializer.new(products,
        each_serializer: ProductSerializer)
      response_success t("api.success"), result
    else
      response_not_found t "api.error_products_not_found"
    end
  end
end
