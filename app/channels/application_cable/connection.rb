module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      if current_user.instance_of?(Admin)
        logger.add_tags "ActionCable", current_user.email
      else
        logger.add_tags "ActionCable", current_user.name
      end
    end

    protected
    def find_verified_user
      verified_user = User.find_by(id: cookies.signed["user.id"]) || (env["warden"].user :admin)
      cookie_user = verified_user.instance_of?(Admin) ? "admin" : "user"
      if verified_user && cookies.signed["#{cookie_user}.expires_at"] > Time.now
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
