class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_domain_present
  def show
    if Category.exists? params[:id]
      @category = Category.find params[:id]
      products = active_products_in_domain_by_category @domain, @category
      @products = Kaminari.paginate_array(products)
        .page(params[:page]).per Settings.common.products_per_page
    else
      flash[:danger] = t "flash.danger.load_category"
      redirect_to root_path
    end
  end
end
