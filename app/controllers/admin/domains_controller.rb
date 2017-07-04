class Admin::DomainsController < AdminController
  def index
    @domains = Domain.all.page(params[:page]).per Settings.common.per_page
  end

  def show
    domain = Domain.find_by params[:id]
    if domain.present?
      users = domain.users.map(&:name)
      shops = domain.shops.map(&:name)
    end
    respond_to do |format|
      format.json do
        render json: {users: users, shops: shops}
      end
    end
  end
end
