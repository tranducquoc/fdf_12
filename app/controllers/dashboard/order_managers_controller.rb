class Dashboard::OrderManagersController < BaseDashboardController
  before_action :load_shop, only: [:index, :update]

  def index
    @order_products_done = OrderProduct.in_date(params[:start_date], params[:end_date])
      .order_by_date.history_by_day_with_status(@shop.id,
      OrderProduct.statuses[:done]).group_by{|i| l(i.created_at, format: :custom_date)}
    @order_products_reject = OrderProduct.in_date(params[:start_date], params[:end_date])
      .order_by_date.history_by_day_with_status(@shop.id,
      OrderProduct.statuses[:rejected]).group_by{|i| l(i.created_at, format: :custom_date)} 
    if request.xhr?
      @params = params
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if params[:type].to_i == Settings.type_order_products_done
      @order_products = OrderProduct.history_by_day_with_status(@shop.id,
        OrderProduct.statuses[:done]).group_by{|i| l(i.created_at, format: :short_date)}
      if params[:start].present? && params[:end].present?
        @order_products = @order_products
          .select {|key| (params[:start]..params[:end]).include? key}
      else
        @order_products = @order_products
          .select {|key| key == Time.now.strftime(t "time.formats.short_date")}
      end
    else
      @order_products = OrderProduct.history_by_day_with_status(@shop.id,
        OrderProduct.statuses[:rejected]).group_by{|i| l(i.created_at, format: :short_date)}
      if params[:start].present? && params[:end].present?
        @order_products = @order_products
          .select {|key| (params[:start]..params[:end]).include? key}
      else
        @order_products = @order_products
          .select {|key| key == Time.now.strftime(t "time.formats.short_date")}
      end
    end
    file_name = I18n.l(DateTime.now, format: :short_date).to_s
    respond_to do |format|
      format.html
      format.xls do
        headers["Content-Disposition"] = "attachment; filename=\"#{file_name}.xls\""
        headers["Content-Type"] ||= Settings.xls
      end
      format.csv do
        headers["Content-Disposition"] = "attachment; filename=\"#{file_name}.csv\""
        headers["Content-Type"] ||= Settings.csv
      end
    end
  end

  private
  def load_shop
    if Shop.exists? params[:shop_id]
      @shop = Shop.find_by id: params[:shop_id]
      shop_manager = @shop.shop_managers.find_by(user_id: current_user.id)
      unless shop_manager.present? && (shop_manager.owner? || shop_manager.manager?)
        flash[:danger] = t "not_have_permission"
        redirect_to dashboard_shops_path
      end
    else
      flash[:danger] = t "flash.danger.load_shop"
      redirect_to dashboard_shops_path
    end
  end
end
