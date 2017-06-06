class ShopManagerService
  def initialize current_user, user, shop
    @current_user = current_user
    @user = user
    @shop = shop
  end

  def change_owner_shop
    ActiveRecord::Base.transaction do
      begin
        all_shop_by_domains = []
        @current_user.user_domains.each do |current_user|
          @user.user_domains.each do |user|
            if current_user.domain_id == user.domain_id
              all_shop_by_domains << ShopDomain.select_all_shop_by_domain(user.domain_id,
                @shop.id)
            end
          end
        end
        @shop.update_attributes! owner_id: @user.id
        only_shop_domain = []
        all_shop_by_domains.each do |shop|
          if shop.present?
            only_shop_domain << shop.first.domain_id
          end
        end
        ShopDomain.not_in_shop_domain(only_shop_domain).delete_all shop_id: @shop.id
        @shop.products.each do |product|
          ProductDomain.not_in_shop_domain(only_shop_domain)
            .destroy_all(product_id: product.id)
        end
        user_shop_owner = ShopManager.find_by user_id: @current_user.id,
          shop_id: @shop.id, role: :owner
        if user_shop_owner.present?
          user_shop_owner.destroy!
        end
        user_shop_manager = ShopManager.find_by user_id: @user.id,
          shop_id: @shop.id, role: :manager
        if user_shop_manager.present?
          user_shop_manager.destroy!
        end
        ShopManager.create! user_id: @user.id, shop_id: @shop.id, role: :owner
        return true
      rescue
        return false
      end
    end
  end
end
