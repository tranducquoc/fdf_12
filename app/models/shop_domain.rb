class ShopDomain < ApplicationRecord
  belongs_to :domain
  belongs_to :shop

  enum status: {waiting: 0, active: 1, blocked: 2}
end
