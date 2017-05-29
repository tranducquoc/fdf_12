class V1::Dashboard::ProductsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: [:create, :update]
  before_action :load_shop, only: :create

  def create
    shop_manager = ShopManager.find_by user_id: current_user.id, shop_id: @shop.id
    if shop_manager.present? && (shop_manager.owner? || shop_manager.manager?)
      @product = @shop.products.new product_params
      result = CreateProductService.new(@product, @shop).create
      case result.first
      when Settings.api_type_error
        response_error result.last
      when Settings.api_type_success
        response_success result.last
      end
    else
      response_error t "not_have_permission"
    end
  end

  def update
    product = Product.find_by id: params[:id]
    if product
      if product.update_attributes product_params
        response_success t "api.success"
      else
        response_error t "flash.danger.dashboard.edit_product"
      end
    else
      response_not_found t "flash.danger.dashboard.product.not_found"
    end
  end

  private
  def load_shop
    @shop = Shop.find_by id: params[:product][:shop_id]
    unless @shop.present?
      response_not_found t "api.not_found"
    end
  end

  def product_params
    params.require(:product).permit(:name, :description, :price,
      :category_id, :image, :status, :tag_list, :start_hour, :end_hour).merge! user_id: current_user.id
  end
end
