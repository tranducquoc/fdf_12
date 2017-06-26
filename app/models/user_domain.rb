class UserDomain < ApplicationRecord
  acts_as_paranoid
  strip_attributes only: [:description, :name]

  belongs_to :user
  belongs_to :domain

  enum role: {owner: 0, manager: 1, member: 2}

  before_destroy :destroy_shop_manager_domain

  scope :user_ids_by_domain, -> domain do
    where(domain_id: domain.id, role: :manager).pluck :user_id
  end

  scope :users_by_domain, -> domain_id {where domain_id: domain_id}
  scope :list_all_user_domains, -> domain {where domain_id: domain}

  def create_event_add_user_domain user_id
    Event.create message: :join_domain,
      user_id: user_id, eventable_id: self.domain.id, eventable_type: UserDomain.name,
      eventitem_id: self.user.id
  end

  def create_event_add_manager_domain user_id
    if self.manager?
      Event.create message: self.role,
        user_id: user_id, eventable_id: self.domain.id, eventable_type: Domain.name,
        eventitem_id: self.id
    elsif self.member?
      Event.create message: self.role,
        user_id: user_id, eventable_id: self.domain.id, eventable_type: Domain.name,
        eventitem_id: self.user.id
    end
  end

  private
  def destroy_shop_manager_domain
    self.user.shop_managers.each do |shop_manager|
      if shop_manager.owner?
        shop_manager.shop.shop_domains.by_domain(self.domain).destroy_all
      elsif shop_manager.manager?
        shop_manager.shop_manager_domains.by_domain(self.domain).destroy_all
      end
    end
  end
end
