class Admin::UsersController < AdminController
  load_and_authorize_resource

  def index
  end

  def edit
  end

  def update
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
end
