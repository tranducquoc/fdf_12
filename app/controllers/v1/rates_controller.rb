class V1::RatesController < V1::BaseController
  skip_before_filter :verify_authenticity_token, only: :create
  before_action :load_shop, only: :create

  def create
    if params[:rate_point].to_i > Settings.min_rate_point && params[:rate_point].to_i <= Settings.max_rate_point
      rate = Rate.find_or_initialize_by rater_id: current_user.id, rateable_id: @shop.id,
        rateable_type: Shop.name, dimension: :rate
      rate.stars = params[:rate_point].to_i
      if rate.save
        rate.update_rating_cache
        point = @shop.average(Settings.rate).avg
        response_success t("api.success"), point
      else
        response_error t "api.error"
      end
    else
      response_error t "api.error"
    end
  end

  private

  def load_shop
    @shop = Shop.find_by id: params[:shop_id]
    return if @shop.present?
    response_not_found t "api.not_found"
  end
end
