class OrderFastsController < ApplicationController
  before_action :authenticate_user!

  def create
    domain_id = session[:domain_id]
    if domain_id.present?
      product = Product.find_by id: params[:product_id]
      if product.present?
        ActiveRecord::Base.transaction do
          begin
            order = current_user.orders.new
            order.domain_id = domain_id.to_i
            order.total_pay = product.price * params[:quantity].to_i
            order.shop_id = product.shop_id
            order.save
            order.create_event_order if checked_notification_setting?(Settings.index_two_in_array)
            order_product = order.order_products.new
            order_product.user_id = current_user.id
            order_product.product_id = product.id
            order_product.price = product.price
            order_product.quantity = params[:quantity].to_i
            order_product.notes = params[:note]
            order_product.save
            flash[:success] = t "cart_quick.create_order_fast.success"
            render json: {url: orders_path}
          rescue
            flash[:success] = t "cart_quick.create_order_fast.error"
            render json: {url: ""}
          end
        end
      else
        flash[:success] = t "cart_quick.create_order_fast.error"
        render json: {url: ""}
      end
    else
      flash[:success] = t "cart_quick.create_order_fast.error"
      render json: {url: ""}
    end
  end
end
