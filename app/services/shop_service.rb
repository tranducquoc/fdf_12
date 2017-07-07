class ShopService
  def initialize shops
    @shops = shops
  end

  def get_information_all_shops
    result = []
    @shops.each do |s|
      shop_hash = s.attributes.slice :id, :name, :description, :status,
        :averate_rating, :owner_id
      shop_hash["avatar"] = s.avatar
      shop_hash["cover_image"] = s.cover_image
      shop_hash["owner_name"] = s.owner_name
      shop_hash["owner_email"] = s.owner_email
      shop_hash["owner_avatar"] = s.owner_avatar
      shop_managers = s.shop_managers
      shop_manager_array = []
      shop_managers.each do |sm|
        shop_manager_hash = sm.attributes.slice :id, :user_id, :shop_id, :role
        shop_manager_hash["user_name"] = sm.user_name
        shop_manager_hash["avatar"] = sm.user_avatar
        shop_manager_array << shop_manager_hash
      end
      shop_hash["shop_managers"] = shop_manager_array
      shop_hash["total_products"] = s.products.size
      result << shop_hash
    end
    result
  end
end
