class ShopDomain < ApplicationRecord
  belongs_to :domain
  belongs_to :shop

  enum status: {wait: 0, active: 1, blocked: 2}

  scope :waiting, ->{where status: :wait}
  scope :actived, ->{where status: :active}
end
