require 'rails_helper'

RSpec.describe Ads::PostsController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  let(:domain) {FactoryGirl.create :domain}
  let(:user_domain) {FactoryGirl.create :user_domain, user: user, domain: domain}
  let(:invalid_post_params) {FactoryGirl.attributes_for :post}

  describe "GET #index" do
    it "returns http success" do
      get :index, domain_id: user_domain.domain.slug
      expect(response).to have_http_status(302)
    end
  end

  describe "POST #create" do
    before {invalid_post_params[:title] = ""}
    before {invalid_post_params[:content] = ""}

    it "failed to create post" do
      sign_in user

      post(:create, {domain_id: user_domain.domain.slug, post: invalid_post_params, format: :js})
      expect(response).to redirect_to domain_ads_posts_path domain
    end
  end
end
