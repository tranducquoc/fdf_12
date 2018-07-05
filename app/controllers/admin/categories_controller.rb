class Admin::CategoriesController < AdminController
  load_and_authorize_resource
  before_action :load_categories, except: [:index, :destroy]

  def index
    @categories = Category.is_parent
  end

  def new
    @default_category_id = params[:cate_id]
  end

  def create
    if @category.save
      flash[:success] = t "flash.success.admin.created_category"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "flash.danger.admin.created_category"
      render :new
    end
  end

  def edit
    @default_category_id = @category.parent_id
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "flash.success.admin.updated_category"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "flash.danger.admin.updated_category"
      render :edit
    end
  end

  def destroy
    if @category.products.any?
      flash[:warning] = t "flash.warning.admin.deleted_category"
    else
      if @category.destroy
        flash[:success] = t "flash.success.admin.deleted_category"
      else
        flash[:danger] = t "flash.danger.admin.deleted_category"
      end
    end
    redirect_to admin_categories_path
  end

  private
  def category_params
    params.require(:category).permit :name, :parent_id
  end

  def load_categories
    @categories = Category.all
  end
end
