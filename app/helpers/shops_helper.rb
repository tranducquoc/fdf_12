module ShopsHelper
  def check_shop_on_off shop
    shop.status_on_off == Settings.shop_status_off ? t("shop_was_closed") : t("shop_was_open")
  end

  def follow_shop_button shop
    if shop.followed_by? current_user
      link_to "#", class: "btn btn-danger btn-follow unfollow-shop" do
        raw '<i class="fa fa-minus-square-o" aria-hidden="true"></i> ' +
        t("unfollow")
      end
    else
      link_to "#", class: "btn btn-warning btn-follow follow-shop" do
        raw '<i class="fa fa-check-square-o" aria-hidden="true"></i> ' +
        t("follow")
      end
    end
  end
end
