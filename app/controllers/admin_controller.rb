class AdminController < ActionController::Base
  before_action :authenticate_admin!, :set_admin_ability, :load_events

  layout "admin_lte_2"

  private

  def set_admin_ability
    if admin_signed_in?
      @current_ability ||= Ability.new current_admin
    end
  end

  def load_events
    @events = Event.events_of_admin.by_date
  end
end
