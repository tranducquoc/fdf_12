class StaticPagesController < ApplicationController
  before_action :load_data, only: :home

  def home
    if user_signed_in?
      load_data_for_user
    else
      @shops = Shop.top_shops.decorate
      @products = Product.top_products
    end
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
      @shops = Shop.top_shops.decorate
      @products = Product.top_products
    end
  end
end
