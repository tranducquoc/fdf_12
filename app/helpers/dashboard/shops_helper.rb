module Dashboard::ShopsHelper
  def orders_pending_of_shop shop
    shop.orders.pending.size
  end

  def time_run_close_shop shop
    job = Delayed::Job.find_by id: shop.delayjob_id
    return job.run_at.strftime(Settings.fomat_time_coutdown) if job.present?
  end

  def load_tag_total_domain shop
    domain_ids = shop.shop_domains.by_status_approved.map(&:domain_id)
    domains = Domain.list_domain_by_ids domain_ids
    content_tag :div do
      concat(label_tag("", class: "user_role_manager") do
        concat(content_tag(:i, "", class: "glyphicon glyphicon-globe"))
        concat(t("professed") + ": " + domains.professed.size.to_s)
      end)
      concat(label_tag("", class: "user_role_owner")do
        concat(content_tag( :i, "", class: "glyphicon glyphicon-lock"))
        concat(t("secret") + ": " + domains.secret.size.to_s)
      end)
    end
  end

  def load_tag_owner_or_manager shop
    if shop.is_owner? current_user
      label_tag "", t("shop_owner"), class: "user_role_owner"
    else
      label_tag "", t("shop_manager"), class: "user_role_manager"
    end
  end

  def load_tag_shop_on_off_pending shop
    if shop.pending?
      label_tag "", t("shop_not_activate"), class: "shop_pending"
    else
      if shop.on?
        label_tag "", t("shop_was_open"), class: "shop_openning"
      else
        label_tag "", t("shop_was_closed"), class: "shop_closed"
      end
    end
  end

  def load_tag_coutdown_auto_close_shop shop
    if shop.openforever?
      label_tag "", Settings.time_none, class: "shop_manualy"
    else
      if shop.on?
        label_tag "", Settings.time_none, class: "shop_clock shop_auto_close",
          "data-timeclose": time_run_close_shop(shop), id: shop.id
      else
        label_tag "", Settings.time_none, class: "shop_clock", "data-timeclose": ""
      end
    end
  end

  def load_icon_status_domain domain
    if domain.professed?
      content_tag :i, "", class: "glyphicon glyphicon-globe"
    else
      content_tag :i, "", class: "glyphicon glyphicon-lock"
    end
  end
end
