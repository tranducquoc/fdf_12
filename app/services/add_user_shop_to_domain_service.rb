class AddUserShopToDomainService
  def initialize user, domain
    @domain = domain
    @user = user
  end

  def add
    ActiveRecord::Base.transaction do
      @user.own_shops.each do |shop|
        shop_domain = ShopDomain.new shop_id: shop.id, domain_id: @domain.id
        if shop_domain.save!
          AddShopProductToDomainService.new(shop, @domain).add
        else
          return I18n.t "can_not_add_shop"
        end
      end
    end
  end
end
