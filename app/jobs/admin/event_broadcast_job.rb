class Admin::EventBroadcastJob < ApplicationJob
  queue_as :default

  def perform counter, event
    ActionCable.server.broadcast "admin_notification_channel", counter: render_counter(counter),
      event: render_event(event), number: counter, message: I18n.t("dashboard.ads.posts.create.new_post"),
      link: "/admin/posts", title: I18n.t("notice")
  end

  private

  def render_counter counter
    ApplicationController.renderer.render partial: "admin/events/counter", locals: {counter: counter}
  end

  def render_event event
    ApplicationController.renderer.render partial: "admin/events/event", locals: {event: event}
  end
end
