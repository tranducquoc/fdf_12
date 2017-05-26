class Dashboard::ShopManagersController < BaseDashboardController
  before_action :load_shop
  before_action :load_shop_manager, only: :destroy
  before_action :check_user_status_for_action
  before_action :check_owner_or_manager

  def index
    user_ids = []
    user_shop_domain = ShopDomain.list_shop_by_id params[:shop_id]
    user_shop_domain.each do |user_shop|
      user_ids << UserDomain.list_all_user_domains(user_shop.domain_id)
    end
    user_ids = user_ids.flatten.pluck(:user_id).uniq
    @support = Supports::SearchSupport.new(params[:shop_id], user_ids, "")
  end

  def create
    @shop_manager = ShopManager.new user_id: params[:user_id],
      shop_id: params[:shop_id], role: :member
    if @shop_manager.save
      flash[:success] = t "flash.success_message"
    else
      flash[:danger] = t "flash.danger_message"
    end
    redirect_to :back
  end

  def update
    @shop_manager = ShopManager.find_by user_id: params[:user_id], shop_id: params[:shop_id]
    if @shop_manager.update_attributes role: params[:format]
      flash[:success] = t "flash.success_message"
    else
      flash[:danger] = t "flash.danger_message"
    end
    redirect_to :back
  end

  def destroy
    ShopManager.destroy_all user_id: params[:user_id], shop_id: params[:shop_id]
    flash[:success] = t "flash.success_message" if params[:delete_user_domain].present?
    redirect_to :back
  end

  private
  def load_shop
    if Shop.exists? params[:shop_id]
      @shop = Shop.find_by id: params[:shop_id]
    else
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shops_path
    end
  end

  def load_shop_manager
    @shop_manager = ShopManager.find_by id: params[:id]
    unless @shop_manager
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shop_shop_managers_path @shop
    end
  end
end
