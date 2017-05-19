class CreateProductService
  def initialize product, shop
    @product = product
    @shop = shop
  end

  def create
    ActiveRecord::Base.transaction do
      begin
        @product.save
        @shop.domains.each do |domain|
          if check_shop_of_domain? domain
            product_domain = ProductDomain.new product_id: @product.id,
              domain_id: domain.id
            product_domain.save
          end
        end
        return [Settings.api_type_success, I18n.t("api.success")]
      rescue
        return [Settings.api_type_error, I18n.t("flash.danger.dashboard.create_product")]
      end
    end
  end

  def check_shop_of_domain? domain
    shop_domain = ShopDomain.find_by shop_id: @shop.id, domain_id: domain.id
    shop_domain.approved?
  end
end
