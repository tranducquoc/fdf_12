class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_product, only: :show
  before_action :check_domain_present
  before_action :check_show_product, only: :show

  def index
    shop_ids = Shop.shop_in_domain(@domain.id).on.pluck :id
    @products_shop = Product.by_shop_ids(shop_ids).active.search_by_price(params)
      .by_category(params[:category]).sort_by_price(params[:price_sort])
      .page(params[:page]).per Settings.common.products_per_page
    if request.xhr?
      respond_to do |format|
        format.js
      end
    end
  end

  def new
    @product = Product.new
  end

  def show
    @comment = @product.comments.build
    @comments = @product.comments.newest.includes :user
  end

  private
  def load_product
    if Product.exists? params[:id]
      @product = Product.find params[:id]
    else
      flash[:danger] = t "product.not_product"
      redirect_to products_path
    end
  end

  def check_show_product
    unless @product.shop.get_shop_manager_by(current_user).present?
      unless @product.shop.domains.include?(@domain) && @product.active?
        flash[:danger] = t "product.not_allow"
        redirect_to root_path
      end
    end
  end
end
