class SaveDomainService
  def initialize domain, user
    @domain = domain
    @user = user
  end

  def save
    ActiveRecord::Base.transaction do
      if @domain.save
        AddUserToDomainService.new(@user, @domain).add
        return [Settings.api_type_success, I18n.t("save_domain_successfully")]
      else
        return [Settings.api_type_error, I18n.t("save_domain_not_successfully")]
      end
    end
  end
end
