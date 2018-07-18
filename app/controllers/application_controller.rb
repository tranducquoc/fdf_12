require "json_response"

class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :create_cart
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_events
  before_action :check_current_domain
  before_action :load_domain_in_session
  before_action :set_cache_back
  before_action :check_choose_feature

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit :name, :email, :chatwork_id, :avatar, :description,
        :password, :password_confirmation
    end
    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit :name, :email, :chatwork_id, :avatar, :description,
        :password, :password_confirmation, :current_password, :address
    end
  end

  private
  def create_cart
    domain_id = session[:domain_id]
    @cart_domain = CartDomain.build_from_hash session[:cart_domain]
    if domain_id.present?
      @cart = @cart_domain.carts.find{|cart| cart.domain_id == domain_id}
      unless @cart
        @cart = Cart.new domain_id
        @cart_domain.carts << @cart
      end
    else
      @cart = Cart.new Settings.not_find
      @cart_domain.carts << @cart
    end
    @cart_group = @cart.items.group_by(&:shop_id).map  do |q|
      {shop_id: q.first, items: q.second.each.map { |qn| qn }}
    end
  end

  def load_events
    if user_signed_in?
      @events = current_user.events.by_date
    end
  end

  def load_shop
    @shop = Shop.find_by id: params[:shop_id]
    unless @shop
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shops_path
    end
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def params_create_order cart_shop, shop_order
    {user: current_user, total_pay: cart_shop.total_price,
      cart: cart_shop, shop: shop_order, domain: @domain}
  end

  def delete_cart_item_shop shop
    items_by_shop = @cart.items.select{|item| item.shop_id. == shop.id}
    if items_by_shop.present?
      @cart.delete_item items_by_shop
      @cart_domain.add_cart @cart.sort, session[:domain_id]
      session[:cart_domain] = @cart_domain.update_cart
    end
  end

  def load_cart_shop shop_order
    cart_shop = @cart_group.detect {|shop| shop[:shop_id] == shop_order.id}
    items = []
    if cart_shop.present?
      cart_shop[:items].each do |item|
        items << item.to_hash
      end
    else
      redirect_to carts_path
    end
    Cart.new(session[:domain_id], items) if cart_shop.present?
  end

  def check_user_status_for_action
    if current_user.wait?
      flash[:danger] = t "information_user_not_active"
      redirect_to root_path
    end
  end

  def load_domain
    begin
      @domain = if params[:domain_id]
        Domain.friendly.find params[:domain_id]
      elsif params[:id]
         Domain.friendly.find params[:id]
      end
    rescue
      flash[:danger] = t "can_not_load_domain"
      redirect_to root_path
    end
    session[:domain_id] = @domain.id if @domain.present?
  end

  def redirect_to_root_domain
    if (@domain.secret?) && ((!user_signed_in?) || (!current_user.domains.include? @domain))
      redirect_to root_path
    end
  end

  def auto_add_pulbic_domain_for_user
    if user_signed_in? && !current_user.domains.present?
      domain = Domain.first
      create_data_for_domain current_user, domain
    end
  end

  def load_domain_in_session
    domain_id = session[:domain_id]
    @domain = nil
    if domain_id.present?
      @domain = Domain.find_by id: domain_id
    elsif current_user.present?
      @domain = current_user.domains.first
      return unless @domain.present?
      session[:domain_id] = @domain.id
    end
  end

  def load_domain_by_param
    if params[:domain_id].present?
      @choosen_domain = Domain.find_by id: params[:domain_id]
      unless @choosen_domain.present?
        redirect_to :back
        flash[:danger] = t "can_not_load_domain"
      end
      check_user_in_domain(@choosen_domain) unless params[:join_domain].present?
    end
  end

  JsonResponse::STATUS_CODE.each do |status, code|
    define_method "response_#{status}" do |message = "", content = {}|
      render json: JsonResponse.send(status, message, content), status: code
    end
  end

  def set_cache_back
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "#{1.year.ago}"
  end

  def check_current_domain
    if params[:domain_id].present? && current_user.present?
      domain = Domain.find_by id: params[:domain_id]
      domain = Domain.find_by(slug: params[:domain_id]) if !domain.present?
      if domain.present? && UserDomain.find_by(user_id: current_user.id,
        domain_id: domain.id).present?
        if session[:domain_id] != domain.id
          session[:domain_id] = domain.id
        end
      else
        flash[:danger] = t "can_not_load_domain"
        redirect_to root_path
      end
    end
  end

  def check_domain_present
    unless current_user.domains.present?
      flash[:danger] = t "not_have_domain"
      redirect_to root_path
    end
  end

  def check_user_in_domain domain
    unless current_user.is_member_of_domain? domain
      flash[:danger] = t "not_have_permission"
      redirect_to root_path
    end
  end

  def check_choose_feature
    redirect_to intro_features_path if current_user && current_user.domains.present? && request.path == root_path
  end
end
