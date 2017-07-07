class Admin::UpdateGroupUserController < ApplicationController
  def create
    import_group_user = ImportGroupUserService.new(params[:file]).import_group
    flash[:success] = import_group_user
    redirect_to admin_users_path
  end
end
