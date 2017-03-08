class V1::OrdersController < V1::BaseController
  before_action :check_user, only: :index
  before_action :check_domain, only: :index

  def index
    tmp_orders = @user.orders.by_domain @domain_id
    if tmp_orders.present?
      @orders = if params[:start_date].present? && params[:end_date].present?
        tmp_orders.between_date params[:start_date], params[:end_date]
      else
        tmp_orders.on_today.by_date_newest
      end
      params[:status] ||= Settings.filter_status_order.all
      @orders = @orders.send params[:status]
      @order_days = @orders.group_by_orders_by_created_at
      if @order_days.any?
        response_success t("api.success"), (OrdersApiService.new(@order_days).result_json)
      else
        response_not_found t "api.error_orders_list_not_found"
      end
    else
      response_not_found t "api.error_orders_list_not_found"
    end
  end

  private
  def check_user
    @user = User.find_by id: params[:user_id]
    unless @user
      response_not_found t "api.error_user_not_found"
    end
  end
  def check_domain
    @domain_id = Domain.find_by id: params[:domain_id]
    unless @domain_id
      response_not_found t "api.error_domains_not_found"
    end
  end
end
