class Event < ApplicationRecord
  include ActionView::Helpers::DateHelper

  after_create_commit :send_notification

  belongs_to :user
  belongs_to :eventable, polymorphic: true

  scope :by_date, -> {order created_at: :desc}
  scope :unread, -> {where read: false}

  def load_message
    case eventable_type
    when Shop.name
      "#{eventable.name} #{eventable_type} #{I18n.t "notification.shop"}
        :#{message.upcase}"
    when Product.name
      "#{eventable.name} #{eventable_type} #{I18n.t "notification.product"}
        :#{message.upcase}"
    when Order.name
      "#{I18n.t "order"} #{I18n.t "notification.order"}
        :#{message.upcase}"
    when OrderProduct.name
      "#{I18n.t "order_product"} #{I18n.t "notification.status"}
        :#{message.upcase}"
    when User.name
      "#{I18n.t "shop_accept"} #{I18n.t "notification.order"}
        :#{message.upcase}"
    when ShopDomain.name
      domain = Domain.find_by id: eventable_id
      shop_domain = ShopDomain.find_by id: eventitem_id
      check_message domain, shop_domain if shop_domain.present?
    end
  end

  def load_message_time
    case eventable_type
    when Shop.name
      "#{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}"
    when Product.name
      "#{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}"
    when Order.name
      "#{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}"
    when OrderProduct.name
      "#{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}"
    when User.name
      "#{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}"
    when ShopDomain.name
      "#{time_ago_in_words(created_at)} #{I18n.t "notification.ago"}"
    end
  end

  def get_link_img
    case eventable_type
    when Shop.name
      eventable.avatar.url
    when Product.name
      eventable.image.url
    when Order.name
      "#{message}.png"
    when OrderProduct.name
      "#{message}.png"
    when User.name
      Settings.image_url.systemdone
    when ShopDomain.name
      Settings.image_url.systemdone
    end
  end

  def get_link_redirect
    case eventable_type
    when Shop.name
      "/dashboard/shops/#{eventable_id}"
    when Product.name
      "/products/#{eventable_id}/##{eventitem_id}"
    when Order.name
      if message == Settings.notification_new
        "/dashboard/shops/#{eventable_id}/orders/##{eventitem_id}"
      else
        "/orders/##{eventitem_id}"
      end
    when OrderProduct.name
      "/orders##{eventitem_id}"
    when User.name
      "/dashboard/shops/#{eventable_id}/order_managers/##{eventitem_id}"
    when ShopDomain.name
      domain = Domain.find_by id: eventable_id
      shop_domain = ShopDomain.find_by id: eventitem_id
      check_message_for_link shop_domain, domain if shop_domain.present?
    end
  end

  def send_notification
    EventBroadcastJob.perform_now Event.unread.count, self
  end

  def check_message domain, shop_domain
    if shop_domain.pending?
      "#{I18n.t "shop_request"}#{shop_domain.shop.name} #{I18n.t "to_domain"}#{domain.name}"
    elsif shop_domain.approved?
      if user_id == domain.id
        "#{I18n.t "owner_active_shop_request"}#{shop_domain.shop.name} #{I18n.t "to_domain"}#{domain.name}"
      else
        "#{I18n.t "active_shop_request"}#{shop_domain.shop.name} #{I18n.t "to_domain"}#{domain.name}"
      end
    else
      "#{I18n.t "blocked_shop_request"}#{domain.name}"
    end
  end

  def check_message_for_link shop_domain, domain
    if shop_domain.pending?
      "/shop_domains/##{eventitem_id}"
    elsif shop_domain.approved?
      if user_id == domain.id
        "/domains?domain_id=#{eventitem_id}"
      else
        "/domains/#{domain.slug}/dashboard/shops"
      end
    else
      "/domains/#{domain.slug}/dashboard/shops"
    end
  end
end
