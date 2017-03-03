class DashboardShopsApiService

  def domain_info user
    domain_info = []
    user.domains.each do |obj|
      domain_info << {domain_id: obj.id, domain_name: obj.name,
        number_of_users: obj.users.size,
        number_of_shops: obj.shop_domains.approved.size,
        number_of_products: obj.products.size}
    end
    domain_info
  end

  def result_json list_domains, list_shops, domain_info
    {
      shops: ActiveModel::Serializer::CollectionSerializer.new(list_shops,
        each_serializer: ShopSerializer), domains: ActiveModel::
        Serializer::CollectionSerializer.new(list_domains,
      each_serializer: UserDomainSerializer), info: domain_info
    }
  end
end
