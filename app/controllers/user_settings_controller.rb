class UserSettingsController < ApplicationController
  def edit
    if current_user.nil?
      redirect_to root_url
    end
  end

  def update
    if current_user.update_attributes setting_params
      change_language
      flash[:success] = t "edit_user.update_settings_success"
    else
      flash[:warning] = t "edit_user.update_settings_fail"
    end
    redirect_to edit_user_setting_path
  end

  private
  def setting_params
    params.require(:user).permit(:language,
      notification_settings: [:order_request, :order_processed, :send_order],
      email_settings: [:order_request, :order_processed, :send_order])
  end

  def change_language
    I18n.locale = params[:user][:language].to_sym
    session[:locale] = I18n.locale
  end
end
