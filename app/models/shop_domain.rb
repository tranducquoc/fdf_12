class ShopDomain < ApplicationRecord
  acts_as_paranoid
  belongs_to :domain
  belongs_to :shop

  enum status: {pending: 0, approved: 1, rejected: 2}

  scope :select_all_shop_by_domain, ->(user_domain_id, shop_id) do
    select("id, domain_id, shop_id, status")
      .where("domain_id = ? and shop_id = ?", user_domain_id, shop_id)
  end

  scope :not_in_shop_domain, -> only_shop_domain {where.not domain_id: only_shop_domain}
  scope :list_shop_domains, -> domain {where domain_id: domain}
  scope :list_shop_by_id, -> shop {where shop_id: shop}
  scope :by_domain, ->domain {where domain_id: domain.id}
  scope :request_of_domain, ->domain_id {where domain_id: domain_id,
    status: Settings.pending}
  scope :by_status_approved, -> {where status: Settings.request_status.approved}

  def create_event_request_shop user_id, shop_domain
    if shop_domain.pending?
      Event.create message: :pending,
        user_id: user_id, eventable_id: domain.id, eventable_type: ShopDomain.name,
        eventitem_id: self.id
    elsif shop_domain.approved?
      Event.create message: :approved,
        user_id: user_id, eventable_id: domain.id, eventable_type: ShopDomain.name,
        eventitem_id: self.id
    else
      Event.create message: :rejected,
        user_id: user_id, eventable_id: domain.id, eventable_type: ShopDomain.name,
        eventitem_id: self.id
    end
  end
end
