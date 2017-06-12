class DomainService
  def initialize domain, user
    @domain = domain
    @current_user = user
  end

  def destroy
    shop_domains = @domain.shop_domains.select{|s| s.approved?}
    user_domains = @domain.user_domains.select{|s| s.user_id != @current_user.id}
    if shop_domains.present? || user_domains.present?
      return [Settings.api_type_error, I18n.t("missing_delete_domain")]
    else
      ActiveRecord::Base.transaction do
        begin
          @domain.shop_domains.destroy_all
          @domain.user_domains.destroy_all
          @domain.destroy
          return [Settings.api_type_success, I18n.t("delete_domain_success")]
        rescue
          return [Settings.api_type_error, I18n.t("delete_domain_fail")]
        end
      end
    end
  end
end
