class DomainsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_domain, only: [:show, :update]
  before_action :redirect_to_root_domain, only: :show
  before_action :check_user_status_for_action, only: :index
  before_action :active_account, only: :create
  before_action :change_current_feature

  def index
    @own_domains = current_user.domains.by_creator current_user.id
    @member_domains = current_user.domains.member current_user.id
  end

  def new
  end

  def show
    @domains = Domain.professed
    @categories = Category.all
    @shops = Shop.active.shop_in_domain(@domain.id).top_shops.decorate
    @shops_slide = Shop.shop_in_domain(@domain.id)
    shops = @shops_slide.select do |shop|
      shop.status_on_off == Settings.shop_status_on
    end
    @products_shop = []
    shops.each do |t|
      @products_shop << t.products.by_active
    end
    session[:domain_id] = @domain.id
    create_cart
    session[:cart_domain] = @cart_domain
  end

  def create
    @domain = Domain.new domain_params
    save_domain = SaveDomainService.new(@domain, current_user).save
    if save_domain.first == Settings.api_type_success
      session[:domain_id] = @domain.id
      flash[:success] = save_domain.last
      redirect_to domains_path @domain.slug
    else
      flash[:danger] = save_domain.last
      redirect_to :back
    end
  end

  def update
    if @domain.update_attributes edit_domain_params
      flash[:success] = t "save_domain_successfully"
    else
      flash[:danger] = t "save_domain_not_successfully"
    end
    redirect_to :back
  end

  def edit
    if check_manager_domain || check_owner_domain
      domain = Domain.find_by id: params[:id]
      if domain
        if domain.update_attributes edit_domain_params
          flash[:success] = t "save_domain_successfully"
        else
          flash[:danger] = t "save_domain_not_successfully"
        end
      else
        flash[:danger] = t "can_not_load_domain"
      end
    else
      flash[:danger] = t "not_have_permission"
    end
    redirect_to domains_path
  end

  def destroy
    if check_owner_domain
      domain = Domain.find_by id: params[:id]
      if domain
        resulf = DomainService.new(domain, current_user).destroy_domain
        if resulf.first == Settings.api_type_error
          flash[:danger] = resulf.last
        else
          if session[:domain_id] == domain.id
            change_domain = current_user.domains.first
            session[:domain_id] = change_domain.present? ? change_domain.id : nil
          end
          flash[:success] = resulf.last
        end
      else
        flash[:danger] = t "can_not_load_domain"
      end
    else
      flash[:danger] = t "not_have_permission"
    end
    redirect_to domains_path
  end

  private
  def domain_params
    params.require(:domain).permit(:name, :status, :room_chatwork).merge! owner: current_user.id
  end

  def edit_domain_params
    params.require(:domain).permit :name, :status, :room_chatwork
  end

  def active_account
    unless current_user.active?
      flash[:danger] = t "information_user_not_active"
      redirect_to :back
    end
  end

  def check_manager_domain
    user_domain =  UserDomain.find_by domain_id: params[:id],user_id: current_user.id
    return user_domain.present? && user_domain.manager?
  end

  def check_owner_domain
    user_domain =  UserDomain.find_by domain_id: params[:id],user_id: current_user.id
    return user_domain.present? && user_domain.owner?
  end

  def change_current_feature
    session["current_feature"] = domain_path  if session["current_feature"] != domain_path
  end
end
