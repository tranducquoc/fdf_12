class ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_product, only: :show
  before_action :check_domain_present
  before_action :check_show_product, only: :show

  def index
    @shops_slide = Shop.shop_in_domain(@domain.id)
    shops = @shops_slide.select do |shop|
      shop.status_on_off == Settings.shop_status_on
    end
    products_shop = []
    shops.each do |t|
      products_shop << t.products.by_active
    end
    @products_shop = Kaminari.paginate_array(products_shop.flatten).page(
      params[:page]).per(Settings.common.products_per_page)
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
    unless @product.shop.domains.include?(@domain) && @product.active?
      flash[:danger] = t "product.not_allow"
      redirect_to root_path
    end
  end
end
