class SendMessageNewProductToChatworkService
  def initialize product
    @product = product
  end

  def send
    return if !@product.shop.followers.present?
    @product.shop.domains.each do |domain|
      room = domain.room_chatwork
      if room.present? && to_users(room).present?
        ChatWork::Message.create room_id: room, body: message_body(room)
      end
    end
  end

  private

  def to_users room
    to_all = ""
    begin
      members = ChatWork::Member.get room_id: room
      @product.shop.followers.each do |user|
        to_account_id = members.find{|member| member["name"] == I18n.transliterate(user.name)}
        to = to_account_id.present? ? "[To:#{to_account_id["account_id"]}]" : ""
        to_all += to unless to_all.include? to
      end
    rescue
      to_all = ""
    end
    to_all
  end

  def message_body room
    body = ""
    Settings.languages.each do |key, value|
      message = I18n.t("chatwork_new_products", locale: value[:type],
        shop: @product.shop.name, product_name: @product.name, price: @product.price)
      body += message + "\n"
    end
    to_users(room) + "[info]" + Settings.forder_chatwork_title + body + "[/info]"
  end
end
