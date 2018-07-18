class Dashboard::Ads::PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts.page(params[:page])
      .desc.per Settings.common.posts_per_page
  end
end
