class Dashboard::ShopSettingsController < ApplicationController
  before_action :load_shop

  def edit;end

  def update
    @success = @shop.update_attributes setting_params
  end

  private

  def load_shop
    @shop = Shop.find_by slug: params[:id]
    return if @shop
    respond_to do |format|
      format.js {render}
    end
  end

  def setting_params
    params.require(:shop).permit(shop_settings: [:turn_on_shop, :turn_off_shop,
      :order_status, :new_product])
  end
end
