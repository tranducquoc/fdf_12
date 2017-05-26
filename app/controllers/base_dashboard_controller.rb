class BaseDashboardController < ApplicationController
  before_action :authenticate_user!

  def check_owner_or_manager
    shop_manager = ShopManager.find_by user_id: current_user.id, shop_id: params[:shop_id]
    unless shop_manager.present? && (shop_manager.owner? || shop_manager.manager?)
      flash[:danger] = t "not_have_permission"
      redirect_to root_path
    end
  end
end
