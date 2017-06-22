module DomainsHelper

  def find_user_domain user, domain
    UserDomain.find_by user_id: user.id, domain_id: @choosen_domain.id
  end

  def delete_user_domain_btn user_domain
    link_to t("delete"),
      user_domain_path(user_domain,
      domain_id: user_domain.domain_id, delete_user_domain: true),
      method: :delete, data: {confirm: t("common.delete_confirm")},
      class: "btn btn-danger", remote: true
  end

  def domain_manager_action user_domain
    if user_domain.member?
      role = :manager
      text = t("manage_domain.manage")
      classes = "btn btn-primary"
    else
      role = :member
      text = t("manage_domain.remove")
      classes = "btn btn-primary btn-warning"
    end
    link_to text,
      user_domain_path(user_domain, role: role),
      method: :patch, class: classes, remote: true
  end
end
