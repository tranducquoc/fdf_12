class V1::DomainsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :create

  before_action :check_user, only: :create
  before_action :active_account, only: :create

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

  def create
    @domain = Domain.new domain_params
    save_domain = SaveDomainService.new(@domain, @user).save
    save_domain.first == Settings.api_type_success ? response_success(save_domain.last)
      : response_error(save_domain.last)
  end

  private
  def domain_params
    params.require(:domain).permit(:name, :status).merge! owner: @user.id
  end

  def check_user
    @user = User.find_by id: params[:user_id]
    unless @user
      response_not_found t "api.error_user_not_found"
    end
  end

  def active_account
    unless current_user.active?
      response_error = t "information_user_not_active"
    end
  end
end
