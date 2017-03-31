class ProductDomain < ApplicationRecord
  belongs_to :product
  belongs_to :domain

  scope :not_in_shop_domain, -> only_shop_domain {where.not domain_id: only_shop_domain}

end
