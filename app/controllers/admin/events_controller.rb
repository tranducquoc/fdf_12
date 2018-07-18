class Admin::EventsController < AdminController
  def update
    @event = Event.find_by id: params[:id]
    @event.update read: true
  end

  def read_all
    Event.events_of_admin.unread.update_all read: true
    respond_to do |format|
      format.html{redirect_to admin_posts_path}
      format.js
    end
  end
end
