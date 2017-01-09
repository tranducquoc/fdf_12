class AddShopProductToDomainService
  def initialize shop, domain
    @domain = domain
    @shop = shop
  end

  def add
    ActiveRecord::Base.transaction do
      @shop.products.each do |product|
        product_domain = ProductDomain.new product_id: product.id, 
          domain_id: @domain.id
        return I18n.t "can_not_add_product" unless product_domain.save!
      end
    end
  end
end
