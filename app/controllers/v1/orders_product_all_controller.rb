class V1::OrdersProductAllController < V1::BaseController
  skip_before_filter :verify_authenticity_token

  def create
    domain_id = params[:domain_id]
    if domain_id.present?
      data_carts = cart_params
      if data_carts.present?
        if OrderProductAllApiService.new(data_carts, current_user).order_all_product
          response_success t "api.success"
        else
          response_error t "api.error"
        end
      else
        response_not_found t "api.error_orders_list_not_found"
      end
    else
      response_not_found t "api.error_domains_not_found"
    end
  end

  private
  def cart_params
    params.require(:cart).each do |obj|
      obj.permit!
    end
  end
end
