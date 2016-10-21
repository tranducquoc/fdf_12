class Event < ApplicationRecord
  include ActionView::Helpers::DateHelper

  after_create_commit {EventBroadcastJob.perform_later self}

  belongs_to :user
  belongs_to :eventable, polymorphic: true

  scope :by_date, -> {order created_at: :desc}
  scope :unread, -> {where read: false}

  def load_message
    case eventable_type
    when Shop.name
      #{}"#{eventable.name} #{eventable_type} #{I18n.t "notification.shop"}
       # :#{message.upcase},\n #{time_ago_in_words(created_at)}
        #{I18n.t "notification.ago"}"
    when Product.name
     # "#{eventable.name} #{eventable_type} #{I18n.t "notification.product"}
      #  :#{message.upcase} \n #{time_ago_in_words(created_at)}
        #{I18n.t "notification.ago"}"
    when Order.name
      #{}"#{eventable_type} #{I18n.t "notification.order"}
      #  :#{message.upcase} \n #{time_ago_in_words(created_at)}
     #   #{I18n.t "notification.ago"}"
    end
  end

  def get_link_img
    case eventable_type
    when Shop.name
      #eventable.avatar.url
    when Product.name
      #eventable.image.url
    end
  end

  def get_link_redirect
    case eventable_type
    when Shop.name
      "/dashboard/shops/#{eventable_id}"
    end
  end
end
