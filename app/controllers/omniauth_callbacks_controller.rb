class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def create
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)

    if @user.persisted?
      set_flash_message(:notice, :success, kind: auth.provider) if is_navigational_format?
      sign_in @user
      if @user.domains.present?
        redirect_to intro_features_path
      else
        redirect_to root_path
      end
    else
      flash[:notice] = t "auth_fail"
      redirect_to root_path
    end
  end

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in @user
    if @user.domains.present?
      redirect_to intro_features_path
    else
      redirect_to root_path
    end
  end

  alias_method :framgia, :create
end
