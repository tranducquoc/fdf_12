class ShopManagerDomain < ApplicationRecord
  belongs_to :shop_manager
  belongs_to :domain

  scope :by_domain, ->domain_id {where domain_id: domain_id}
end
