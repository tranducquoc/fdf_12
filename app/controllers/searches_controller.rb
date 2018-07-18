class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_status_for_action, only: :new
  before_action :load_shop, only: :new

  def index
    q = params[:search]
    products = Product.by_shop_ids(@domain.shops.map(&:id))
      .active.search(name_or_description_cont: q).result.includes :shop
    posts = Post.all.approved.search(title_or_content_cont: q).result.includes :user, :category
    shops = Shop.shop_in_domain(@domain.id)
      .search(name_or_description_or_owner_name_cont: q)
      .result.includes(:owner).decorate
    @items = products + posts + shops
    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    name = params[:search]
    @support = Supports::SearchSupport.new(params[:shop_id], name)
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
