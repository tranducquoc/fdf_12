module ShopsHelper
  def check_shop_on_off shop
    shop.status_on_off == Settings.shop_status_off ? t("shop_was_closed") : t("shop_was_open")
  end

  def follow_shop_button shop
    if shop.followed_by? current_user
      link_to t("unfollow"), "#",
        class: "btn btn-danger btn-follow unfollow-shop"
    else
      link_to t("follow"), "#",
        class: "btn btn-warning btn-follow follow-shop"
    end
  end
end
