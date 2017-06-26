class ShopManagerDomain < ApplicationRecord
  belongs_to :shop_manager
  belongs_to :domain

  after_destroy :check_destroy_shop_manager

  scope :by_domain, ->domain_id {where domain_id: domain_id}

  private
  def check_destroy_shop_manager
    ShopManager.manager.not_in_any_domain.destroy_all
  end
end
