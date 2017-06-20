module ShopsHelper
  def check_shop_on_off shop
    shop.status_on_off == Settings.shop_status_off ? t("shop_was_closed") : t("shop_was_open")
  end
end
