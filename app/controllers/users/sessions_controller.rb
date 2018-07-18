class Users::SessionsController < Devise::SessionsController
  after_action :set_locate, only: :create
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    redirect_path =
      if resource.domains.present?
        intro_features_path
      else
        root_path
      end
    store_location_for(resource, redirect_path)
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private

  def set_locate
    I18n.locale = current_user.language
    session[:locale] = I18n.locale
  end
end
