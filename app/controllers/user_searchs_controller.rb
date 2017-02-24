class UserSearchsController < ApplicationController
  before_action :load_domain_by_param
  before_action :authenticate_user!

  def index
    q = params[:user_search]
    @users = User.active.search(name_or_email_cont: q).result
    respond_to do |format|
      format.html
      format.js
    end
  end
end
