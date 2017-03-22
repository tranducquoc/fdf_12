class ShopsController < ApplicationController
  before_action :load_shop, only: [:show, :update]
  before_action :authenticate_user!

  def index
    @shops = if @domain.present?
      Shop.includes(:tags).shop_in_domain @domain.id
    else
      Shop.all
    end.active.page(params[:page])
      .per(Settings.common.per_page).decorate
  end

  def show
    @products = @shop.products.active.page(params[:page])
      .per Settings.common.products_per_page
    @shop = @shop.decorate
  end

  def update
    user = User.find_by email: params[:email]
    if user
      current_user.user_domains.each do |current_user|
        current_user.domain_id
        user.user_domains.each do |user_domain|
          if current_user.domain_id == user_domain.domain_id
            @shop.update_attributes owner_id: user.id
            @shop.shop_domains.update_all domain_id: user_domain.domain_id
          else
            @shop.update_attributes owner_id: user_domain.user_id
            @shop.shop_domains.update_all domain_id: user_domain.domain_id
          end
        end
      end
      flash[:success] = t "change_shop"
      redirect_to root_path
    else
      flash[:danger] = t "cant_not_find_shop"
      redirect_to :back
    end
  end

  private
  def load_shop
    if Shop.exists? params[:id]
      @shop = Shop.find params[:id]
    else
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to root_path
    end
  end
end
