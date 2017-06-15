class V1::DomainsController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: [:create, :update, :destroy]
  before_action :active_account, only: :create
  before_action :check_owner_domain, only: :destroy
  before_action :check_manager_or_owner, only: :edit

  def index
    if params[:user_token].present?
      if params.has_key?(:domain_status)
        domain = Domain.by_status params[:domain_status]
        if domain.present?
          response_success t("api.success"), domain
        else
          response_not_found t "api.error_domains_not_found"
        end
      else
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
      end
    else
      response_not_found t "api.error_user_token_not_found"
    end
  end

  def create
    @domain = Domain.new domain_params
    save_domain = SaveDomainService.new(@domain, current_user).save
    save_domain.first == Settings.api_type_success ? response_success(save_domain.last)
      : response_error(save_domain.last)
  end

  def update
    domain = Domain.find_by id: params[:id]
    if domain.present?
      if Domain.statuses[params[:domain_status]].present?
        domain.status = params[:domain_status]
        domain.save ? response_success(t "api.success" )
          : response_error(t "api.change_status_domain_fail")
      else
        response_error t "api.change_status_domain_fail"
      end
    else
      response_not_found t "api.error_domains_not_found"
    end
  end

  def show
    user_domains = current_user.user_domains
    domains = Domain.list_domain_by_ids user_domains.map(&:domain_id)
    result = []
    domains.each do |d|
      domain_hash = d.attributes
      domain_hash["count_user"] = d.users.size
      domain_hash["count_shop"] = d.shop_domains.by_status_approved.size
      domain_hash["count_product"] = d.products.size
      domain_hash["role_of_current_user"] = user_domains.find_by(domain_id:
        d.id).present? ? user_domains.find_by(domain_id: d.id).role : ""
      result << domain_hash
    end
    response_success t("api.success"), result
  end

  def destroy
    resulf = DomainService.new(@domain, current_user).destroy_domain
    if resulf.first == Settings.api_type_error
      response_error resulf.last
    else
      if session[:domain_id] == @domain.id
        change_domain = Domain.find_by owner: current_user.id
        session[:domain_id] = change_domain.id
      end
      response_success resulf.last
    end
  end

  def edit
    domain = Domain.find_by id: params[:id]
    if domain
      if domain.update_attributes edit_domain_params
        response_success t "save_domain_successfully"
      else
        response_error t "save_domain_not_successfully"
      end
    else
      response_not_found t "can_not_load_domain"
    end
  end

  private
  def domain_params
    params.require(:domain).permit(:name, :status).merge! owner: current_user.id
  end

  def edit_domain_params
    params.permit :name, :status
  end

  def active_account
    unless current_user.active?
      response_error = t "information_user_not_active"
    end
  end

  def check_owner_domain
    @domain = Domain.find_by id: params[:id]
    if @domain.present?
      unless @domain.owner == current_user.id
        response_error t "not_have_permission"
      end
    else
      response_not_found t "can_not_load_domain"
    end
  end

  def check_manager_or_owner
    user_domain = UserDomain.find_by user_id: current_user.id, domain_id: params[:id]
    if user_domain.present?
      unless user_domain.owner? || user_domain.manager?
        response_error t "not_have_permission"
      end
    else
      response_not_found t "can_not_load_domain"
    end
  end
end
