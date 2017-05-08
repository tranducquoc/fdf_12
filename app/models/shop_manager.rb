class ShopManager < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  belongs_to :shop

  enum role: {owner: 0, manager: 1, member: 2}

  scope :user_ids_by_shop, -> shopManager do
    where(shop_id: shopManager.shop_id, role: :manager).pluck :user_id
  end

  scope :by_user, ->user_id {where user_id: user_id}

end
