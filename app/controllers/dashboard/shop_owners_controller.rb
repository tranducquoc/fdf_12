class Dashboard::ShopOwnersController < BaseDashboardController
  before_action :check_user_status_for_action
  before_action :load_shop
  before_action :load_new_owner
  before_action :check_owner_of_shop

  def update
    user_shop_owner = ShopManager.find_by user_id: current_user.id,
      shop_id: @shop.id, role: :owner
    user_shop_owner.destroy if user_shop_owner.present?
    user_shop_manager = ShopManager.find_by user_id: @new_owner.id,
      shop_id: @shop.id, role: :manager
    user_shop_manager.destroy if user_shop_manager.present?
    @shop.update_attributes owner_id: @new_owner.id
    @shop.shop_managers.create user_id: @new_owner.id, role: :owner
    @shop.shop_domains.each do |shop_domain|
      shop_domain.destroy unless @new_owner.domains.include? shop_domain.domain
    end
    flash[:success] = t "change_shop"
    redirect_to root_path  
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

  def load_new_owner
    @new_owner = User.find_by email: params[:email]
    unless @new_owner
      flash[:danger] = t "can_not_find_user"
      redirect_to dashboard_shop_path @shop
    end
  end

  def check_owner_of_shop
    unless @shop.is_owner? current_user
      flash[:danger] = t "not_have_permission"
      redirect_to root_path
    end
  end
end
