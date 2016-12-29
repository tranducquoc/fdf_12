class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_domain

  def show
    if User.friendly.exists? params[:id]
      @user = User.friendly.find params[:id]
    else
      flash[:danger] = t "flash.danger_message"
      redirect_to root_path
    end
  end
end
