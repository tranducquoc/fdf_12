class SendShopStatusToChatworkService
  def initialize shop
    @shop = shop
  end

  def send
    @shop.domains.each do |domain|
      rooms = domain.room_chatwork.split(',')
      rooms.each do |room|
        if room.present?
          ChatWork::Message.create room_id: room, body: message_body(room, domain)
        end
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
        else
          time_now = DateTime.now
          if @shop.openforever?
            time = @shop.time_close
          else
            time = @shop.time_auto_close
          end
          if time_now.hour >= time.hour && time_now.min >= time.min
            date = I18n.l((time_now + 1.day), format: :dmy_format)
          else
            date = I18n.l(time_now, format: :dmy_format)
          end
          I18n.t("chatwork_shop_message.open",
            locale: value[:type], owner: @shop.owner_name, shop: @shop.name,
            url: Settings.root_path + Rails.application.routes.url_helpers.domain_shop_path(domain, @shop),
            time: I18n.l(time, format: :short_time), date: date)
        end
      body += message + "\n"
      end
    "[info]" + Settings.forder_chatwork_title + Settings.root_path + Rails.application.routes.url_helpers.domain_shop_path(domain, @shop) + "\n"+ body + "[/info]"
  end

  def to_users room, domain
    to_all = "TO ALL >>>"
    # if @shop.off?
    #   to_all = "TO ALL >>>"
    # else
    #   begin
    #     members = ChatWork::Member.get room_id: room
    #     domain.users.each do |user|
    #       if !user.chatwork_settings.present? ||
    #         user.chatwork_settings[:shop_open] == Settings.serialize_true
    #         to_account_id = members
    #           .find {|member| member["name"] == I18n.transliterate(user.name)}
    #         to_all += "[To:#{to_account_id["account_id"]}]" if to_account_id.present?
    #       end
    #     end
    #   rescue
    #     to_all = ""
    #   end
    # end
    to_all
  end
end
