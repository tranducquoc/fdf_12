class SearchService
  def initialize shops
    @shops = shops
  end

  def include_info_owner
    result = []
    @shops.each do |s|
      shop_hash = s.slice :id, :name, :description, :status, :avatar, :averate_rating, :owner_id
      shop_hash["owner_name"] = s.owner_name
      shop_hash["owner_email"] = s.owner_email
      shop_hash["owner_avatar"] = s.owner_avatar
      result << shop_hash
    end
    result
  end
end
