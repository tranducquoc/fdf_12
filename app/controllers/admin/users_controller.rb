class Admin::UsersController < AdminController
  load_and_authorize_resource
  before_action :load_user, only: :update

  def index
  end

  def edit
  end

  def update
    if params[:status].present?
      @user.update_columns status: params[:status]
      redirect_to :back
    else
      if @user.update_attributes user_params
        flash[:success] = t "flash.success.admin.updated_user"
        respond_to do |format|
          format.json do
            render json: {status: @user.status}
          end
          format.html {redirect_to admin_users_path}
        end
      else
        flash[:danger] = t "flash.danger.admin.updated_user"
        render :edit
      end
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash.success.admin.deleted_user"
    else
      flash[:danger] = t "flash.danger.admin.deleted_user"
    end
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :chatwork_id, :avatar,
      :description, :status
  end

  def load_user
    @user = User.find_by id: params[:id]
    unless @user
      redirect_to :back
    end
  end
end
