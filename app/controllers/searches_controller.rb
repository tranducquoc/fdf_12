class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_status_for_action, only: :new
  before_action :load_shop

  def index
    q = params[:search]
    products = Product.in_domain(@domain.id).active.search(name_or_description_cont: q).result
      .includes :shop
    shops = Shop.shop_in_domain(@domain.id).search(name_or_description_or_owner_name_cont: q).result
      .includes(:owner).decorate
    @items = products + shops
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    name = params[:search]
    user_ids = []
    user_shop_domain = ShopDomain.list_shop_by_id params[:shop_id]
    user_shop_domain.each do |user_shop|
      user_ids << UserDomain.list_all_user_domains(user_shop.domain_id)
    end
    user_ids = user_ids.flatten.pluck(:user_id).uniq
    @support = Supports::SearchSupport.new(params[:shop_id], user_ids, name)
    respond_to do |format|
      format.js
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
end
