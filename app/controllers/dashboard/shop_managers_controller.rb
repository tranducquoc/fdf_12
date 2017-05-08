class Dashboard::ShopManagersController < BaseDashboardController
  before_action :load_shop
  before_action :load_shop_manager, only: :destroy
  before_action :check_user_status_for_action

  def index
    user_domain = Domain.find_by id: session[:domain_id]
    @users = user_domain.users if user_domain.users.present?
    @shops_managers = ShopManager.all
    @shop_manager = ShopManager.find_by shop_id: params[:shop_id]
  end

  def create
    @shop_manager = ShopManager.new user_id: params[:user_id],
      shop_id: params[:shop_id], role: :member
    if @shop_manager.save
      flash[:success] = t "flash.success_message"
    else
      flash[:danger] = t "flash.danger_message"
    end
    redirect_to dashboard_shop_shop_managers_path @shop
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
      @shop = Shop.find params[:shop_id]
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
