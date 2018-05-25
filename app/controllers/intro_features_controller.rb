class IntroFeaturesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :check_choose_feature

  def index; end
end
