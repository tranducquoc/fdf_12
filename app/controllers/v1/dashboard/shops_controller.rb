class V1::Dashboard::ShopsController < V1::BaseController
  def index
    user_id = params[:user_id]
    if user_id.present?
      user = User.find_by id: user_id
      if user.present?
        @list_domains = user.domains
      else
        response_not_found t "api.error_user_not_found"
      end
      @list_shops = Shop.all.select do |shop|
        shop.owner_id.to_s == user_id
      end
      @domain_info = DashboardShopsApiService.new.domain_info user
    else
      response_not_found t "api.error_user_not_found"
    end
    if @list_domains.present? && @list_shops.present?
      response_success t("api.success"), (DashboardShopsApiService.
        new.result_json @list_domains, @list_shops, @domain_info)
    end
  end
end
