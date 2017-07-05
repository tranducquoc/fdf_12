class V1::ListMembersController < V1::BaseController
  def index
    if params[:domain_id]
      user_domains = UserDomain.list_all_user_domains params[:domain_id]
      result = ActiveModelSerializers::SerializableResource.new(
        User.list_all_users user_domains.map(&:user_id),
          each_serializer: UserSerializer)
      if result.present?
        response_success t("api.success"), result
      else
        response_not_found t "api.error_user_not_found"
      end
    else
      response_not_found t "api.error_domains_not_found"
    end
  end

  def new
    domain = Domain.find_by id: params[:domain_id]
    if domain
      users_not_in_domain = User.not_in_domain domain
      if users_not_in_domain
        response_success t("api.success"), users_not_in_domain
      else
        response_error t "api.not_found"
      end
    else
      response_not_found t "api.error_domains_not_found"
    end
  end
end
