module Supports
  class UserDomain
    attr_reader :added_users, :users

    def initialize user_search, domain
      @user_search = user_search
      @domain = domain
    end

    def added_users
      @domain.users.active.search(name_or_email_cont: @user_search).result
    end

    def users
      User.active.not_in_domain(@domain)
        .search(name_or_email_cont: @user_search).result
    end
  end
end
