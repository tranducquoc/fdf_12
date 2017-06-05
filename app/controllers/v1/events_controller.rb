class V1::EventsController < V1::BaseController

  def index
    events = current_user.events.by_date
    if events.present?
      response_success t("api.success"), events
    else
      response_not_found t "common.no_notifications"
    end
  end
end
