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
    shops = []
    list_shops.each do |shop|
      shop_domain = []
      shop_info = []
      list_domains.each do |domain|
        if domain.shops.include? shop
          shop_domain << {domain_id: domain.id, status: shop.request_status(domain).status}
        else
          shop_domain << {domain_id: domain.id, status: ""}
        end
      end
      domain_info.each do |obj|
        shop_info << obj
      end
      shops << {shop: shop, shop_domain: shop_domain, shop_info: shop_info}
    end
    shops
  end
end
