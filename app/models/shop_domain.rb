class ShopDomain < ApplicationRecord
  belongs_to :domain
  belongs_to :shop

  enum status: {pending: 0, approved: 1, rejected: 2}

  scope :by_domain, ->domain {where domain_id: domain.id}
end
