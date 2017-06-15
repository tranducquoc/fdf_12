class Dashboard::ShopManagersController < BaseDashboardController
  before_action :load_shop
  before_action :load_shop_manager, only: :destroy
  before_action :check_user_status_for_action
  before_action :check_owner_or_manager

  def index
    @support = Supports::SearchSupport.new(params[:shop_id], "")
  end

  def create
    @shop_manager = ShopManager.new user_id: params[:user_id],
      shop_id: params[:shop_id], role: :manager
    if @shop_manager.save
      @shop_manager
    else
      flash[:danger] = t "flash.danger_message"
      redirect_to :back
    end

  end

  def destroy
    @shop_manager = ShopManager.find_by user_id: params[:user_id],
      shop_id: params[:shop_id], role: :manager
    if @shop_manager
      if @shop_manager.destroy
        @shop_manager
      else
        flash[:danger] = t "flash.danger_message"
        redirect_to :back
      end
    else
      flash[:danger] = t "flash.danger_message"
      redirect_to :back
    end
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
