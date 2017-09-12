class V1::Dashboard::OrdersController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :update
  before_action :check_owner_or_manager, only: :index
  before_action :load_order, only: :update

  def index
    orders = Order.orders_of_shop_pending params[:shop_id]
    result = ActiveModel::Serializer::CollectionSerializer.new(orders,
      each_serializer: OrderSerializer)
    response_success t("api.success"), result
  end

  def update
    if @order.shop.shop_managers.find_by user_id: current_user.id
      case
      when params[:paid] == true.to_s
        update_paid @order, true
      when params[:paid] == false.to_s
        update_paid @order, false
      else
        response_error t "api.error"
      end
    else
      response_error t "not_have_permission"
    end
  end

  private

  def update_paid order, value
    if order.update_attributes is_paid: value
      response_success t "api.success"
    else
      response_error t "api.error"
    end
  end

  def load_order
    @order = Order.find_by id: params[:id]
    unless @order.present?
      response_not_found t "api.not_found"
    end
  end
end
