class StaticPagesController < ApplicationController
  before_action :load_data, only: :home
  layout "index", only: :index
  caches_page :index

  def index
    rebase_data
    redirect_to root_path if user_signed_in?
  end
  
  def home
    if user_signed_in?
      load_data_for_user
    else
      redirect_to index_path
    end
  end

  def show
    @professed_domains = Domain.professed
  end

  private
  def load_data
    @categories = Category.all
    @tags = ActsAsTaggableOn::Tag.all
    @domains = Domain.professed
  end

  def load_data_for_user
    if current_user.domains.present?
      redirect_to domain_path(current_user.domains.first)
    else
      redirect_to canhan_path
    end
  end

  def rebase_data
    
    ProductDomain.destroy_all
    Domain.all.default.each do |domain|
      domain.user_domains.destroy_all
      domain.shop_domains.destroy_all
      domain.orders.destroy_all
      Event.by_model_and_id(Domain.name, domain.id).destroy_all
      Event.by_model_and_id(ShopDomain.name, domain.id).destroy_all
      Event.by_model_and_id(UserDomain.name, domain.id).destroy_all
      domain.destroy
    end
    ShopManager.all.each do |manager|
      user = manager.user
      shop = manager.shop
      if manager.shop_manager_domains.blank? && !manager.owner?
      user.domains.each do |domain|
        if shop.domains.include? domain
          manager.shop_manager_domains.create domain_id: domain.id
        end
      end
      end
    end
    Order.all.each do |order|
      order.update_attributes is_paid: true
    end
  end
end
