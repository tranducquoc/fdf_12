class ShopDomainApiService
  def initialize shop_domain, user, status
    @shop_domain = shop_domain
    @user = user
    @status = status
  end

  def change_status
    domain = @shop_domain.domain
    if domain.owner == @user.id
      if @shop_domain.pending?
        ActiveRecord::Base.transaction do
          begin
            if @shop_domain.update_attributes status: @status
              if @shop_domain.approved?
                shop = @shop_domain.shop
                shop.products.find_each do |product|
                  product_domain = ProductDomain.new product_id: product.id,
                  domain_id: domain.id
                  product_domain.save
                end
                return [Settings.api_type_success, I18n.t("api.success")]
              elsif @status == ShopDomain.statuses.key(Settings.shop_domain_status_rejected_key)
                return [Settings.api_type_success, I18n.t("api.success")]
              end
            end
          rescue
            return [Settings.api_type_success, I18n.t("api.error")]
          end
        end
      else
        return [Settings.api_type_success, I18n.t("api.error")]
      end
    else
      return [Settings.api_type_not_found, I18n.t("api.not_owner_domain")]
    end
  end
end
