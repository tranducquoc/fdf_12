class V1::BaseController < ApplicationController
  acts_as_token_authentication_handler_for User

  def check_owner_or_manager
    shop_manager = ShopManager.find_by user_id: current_user.id, shop_id: params[:shop_id]
    unless shop_manager.present? && (shop_manager.owner? || shop_manager.manager?)
      response_error t "not_have_permission"
    end
  end
end
