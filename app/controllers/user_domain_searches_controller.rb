class UserDomainSearchesController < ApplicationController
  before_action :load_domain_by_param
  before_action :authenticate_user!

  def index
    q = params[:user_search]
    @user_domain = Supports::UserDomain.new q, @choosen_domain
    respond_to do |format|
      format.html
      format.js
    end
  end
end
