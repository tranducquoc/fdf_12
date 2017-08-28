class SendShopStatusToChatworkService
  def initialize shop
    @shop = shop
  end

  def send
    @shop.domains.each do |domain|
      room = domain.room_chatwork
      if room.present? && to_users(room, domain).present?
        ChatWork::Message.create room_id: room, body: message_body(room, domain)
      end
    end
  end

  private

  def message_body room, domain
    body = ""
    Settings.languages.each do |key, value|
      message =
        if @shop.off?
          I18n.t("chatwork_shop_message.close",
            locale: value[:type], owner: @shop.owner_name, shop: @shop.name)
        elsif @shop.openforever?
          I18n.t("chatwork_shop_message.open_forever",
            locale: value[:type], owner: @shop.owner_name, shop: @shop.name,
            url: Settings.root_path + Rails.application.routes.url_helpers.shop_path(@shop))
        else
          time = @shop.time_auto_close
          I18n.t("chatwork_shop_message.open",
            locale: value[:type], owner: @shop.owner_name, shop: @shop.name,
            url: Settings.root_path + Rails.application.routes.url_helpers.shop_path(@shop),
            hour: time.hour, min: time.min)
        end
      body += "\n" + message + Settings.diliver_dot
      end
    to_users(room, domain)+ "\n" + "[info]" + Settings.forder_chatwork_title + body + "[/info]"
  end

  def to_users room, domain
    to_all = ""
    begin
      members = ChatWork::Member.get room_id: room
      domain.users.each do |user|
        if !user.chatwork_settings.present? ||
          user.chatwork_settings[:shop_open] == Settings.serialize_true
          to_account_id = members
            .find {|member| member["name"] == I18n.transliterate(user.name)}
          to_all += "[To:#{to_account_id["account_id"]}]" if to_account_id.present?
        end
      end
    rescue
      to_all = ""
    end
    to_all
  end
end
