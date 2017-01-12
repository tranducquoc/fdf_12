class Admin::RequestShopDomainsController < AdminController
  def index
    @requests = RequestShopDomain.by_pending.page(params[:page])
      .per Settings.common.per_page
  end
end
