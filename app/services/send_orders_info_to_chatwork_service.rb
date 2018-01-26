class SendOrdersInfoToChatworkService
  def initialize orders
    @orders = orders
  end

  def send
    @orders.group_by{|o| o.domain}.each do |domain, orders|
      rooms = domain.room_chatwork.split(',')
      notified_users = []
      rooms.each do |room|
        to_users = to_users room, orders, notified_users
        if room.present? && to_users[:message_to].present?
          ChatWork::Message.create room_id: room, body: message_body(room, orders, to_users[:message_to])
          notified_users = to_users[:notified_users]
        end
      end
    end
  end

  private

  def to_users room, orders, notified_users
    message_to = ""
    begin
      members = ChatWork::Member.get room_id: room
      orders.each do |order|
        if check_order(order)
          account = members.find do |member|
            member["account_id"] == order.user_chatwork_id.to_i && !notified_users.include?(member["account_id"])
          end
          to = account.present? ? "[To:#{account["account_id"]}]" : ""
          message_to += to unless message_to.include? to
          notified_users << account["account_id"] if account.present?
        end
      end
    rescue
      message_to = ""
    end
    {message_to: message_to, notified_users: notified_users}
  end

  def message_body room, orders, message_to
    body = ""
    Settings.languages.each do |key, value|
      body += I18n.t("chatwork_order_message", locale: value[:type], shop: @orders.first.shop_name) + "\n"
    end
    message_to + "[info]" + Settings.forder_chatwork_title + body + "[/info]"
  end

  def check_order order
    (!order.is_paid && order.order_products.done.present?) &&
    (order.user.chatwork_settings[:chatwork_processed] != Settings.serialize_false)
  end
end
