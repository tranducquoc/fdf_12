class V1::Dashboard::OrdersController < V1::BaseController
  before_action :check_owner_or_manager, only: :index

  def index
    orders = Order.orders_of_shop_pending params[:shop_id]
    result = ActiveModel::Serializer::CollectionSerializer.new(orders,
      each_serializer: OrderSerializer)
    response_success t("api.success"), result
  end
end
