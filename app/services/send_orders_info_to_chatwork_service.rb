class SendOrdersInfoToChatworkService
  def initialize orders
    @orders = orders
  end

  def send
    @orders.group_by{|o| o.domain}.each do |domain, orders|
      rooms = domain.room_chatwork.split(',')
      @all_members = []
      rooms.each do |r|
        if r.present? && to_users(r, orders).present?
          ChatWork::Message.create room_id: r, body: message_body(r, orders)
          @all_members.concat ChatWork::Member.get(room_id: r)
        end
      end
    end
  end

  private

  def to_users room, orders
    to_all = ""
    begin
      members = ChatWork::Member.get room_id: room
      members = members - @all_members
      orders.each do |order|
        if !order.is_paid && order.order_products.done.present?  &&
          (!order.user.chatwork_settings.present? ||
          order.user.chatwork_settings[:chatwork_processed] == Settings.serialize_true)
          to_account_id = members
            .find {|member| member["account_id"] == order.user_chatwork_id.to_i}
          to = to_account_id.present? ? "[To:#{to_account_id["account_id"]}]" : ""
          to_all += to unless to_all.include? to
        end
      end
    rescue
      to_all = ""
    end
    to_all
  end

  def message_body room, orders
    body = ""
    Settings.languages.each do |key, value|
      message = I18n.t("chatwork_order_message", locale: value[:type],
        shop: @orders.first.shop_name)
      body += message + Settings.diliver_dot + "\n"
    end
    to_users(room, orders) + "[info]" + Settings.forder_chatwork_title + body + "[/info]"
  end

end
