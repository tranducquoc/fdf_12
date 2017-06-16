class Dashboard::ProductsController < BaseDashboardController
  before_action :load_shop
  before_action :load_categories, only: [:edit, :new, :update]
  before_action :load_product, except: [:new, :index, :create]
  before_action :load_products, only: :index

  def new
    @product = @shop.products.new
  end

  def index
    @products.page(params[:page]).per Settings.common.products_per_page
  end

  def show
    @order_item = OrderProduct.find_by id: params[:order_product_id]
    if @order_item
      date = Date.parse @order_item.created_at.to_s
      case
      when @order_item.done?
        @order_products = @product.order_products.order_products_at_date(date)
          .includes(:user).done
      when @order_item.rejected?
        @order_products = @product.order_products.order_products_at_date(date)
          .includes(:user).rejected
      else
        @order_products = @product.order_products.order_products_at_date(date)
          .includes(:user).accepted
      end
      file_name = I18n.l(DateTime.now, format: :short_date).to_s
      respond_to do |format|
        format.html
        format.xls do
          headers["Content-Disposition"] = "attachment; filename=\"#{file_name}.xls\""
          headers["Content-Type"] ||= Settings.xls
        end
        format.csv do
          headers["Content-Disposition"] = "attachment; filename=\"#{file_name}.csv\""
          headers["Content-Type"] ||= Settings.csv
        end
      end
    else
      flash[:danger] = t "flash.danger.dashboard.product.not_found"
      redirect_to root_path
    end
  end

  def edit
  end

  def create
    @product = @shop.products.new product_params
    if @product.save
      flash[:success] = t "flash.success.dashboard.create_product"
      redirect_to dashboard_shop_path @shop
    else
      flash[:danger] = t "flash.danger.dashboard.create_product"
      load_categories
      render :new
    end
  end

  def update
    if @product.update_attributes product_params
      flash[:success] = t "flash.success.dashboard.edit_product"
      respond_to do |format|
        format.json do
          render json: {status: @product.status}
        end
        format.html do
          redirect_to dashboard_shop_path @shop
        end
      end
    else
      flash[:danger] = t "flash.danger.dashboard.edit_product"
      render :edit
    end
  end

  def destroy
    if @product.order_products.any?
      flash[:danger] = t "flash.danger.dashboard.order_product"
    elsif @product.destroy
      flash[:success] = t "flash.success.dashboard.delete_product"
    else
      flash[:danger] = t "flash.danger.dashboard.delete_product"
    end
    redirect_to dashboard_shop_path @shop
    
  end

  private
  def load_shop
    @shop = Shop.find_by slug: params[:shop_id]
    unless @shop.present?
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shop_path
    end
  end

  def product_params
    params.require(:product).permit :id, :name, :description, :price,
      :category_id, :user_id, :image, :status, :tag_list, :start_hour, :end_hour
  end

  def load_categories
    @categories = Category.all
  end

  def load_products
    @products = @shop.products
  end

  def load_product
    @product = @shop.products.find_by slug: params[:id]
    if @products
      flash[:danger] = t "flash.danger.dashboard.product.not_found"
      redirect_to root_path
    end
  end
end
