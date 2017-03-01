class V1::DomainsController < V1::BaseController
  def index
    if params[:user_token].present?
      user_domains = UserDomain.all.select do |t|
        t.user_id.to_s == params[:user_id]
      end
      if user_domains.present?
        result = ActiveModel::Serializer::CollectionSerializer.new(user_domains,
          each_serializer: UserDomainSerializer)
        response_success t("api.success"), result
      else
        response_not_found t "api.error_domains_not_found"
      end
    else
      response_not_found t "api.error_user_token_not_found"
    end
  end
end
