require 'rails_helper'

RSpec.describe Ads::PostsController, type: :controller do
  let(:domain) {Domain.create name: "Da Nang Office"}
  let(:user) {FactoryGirl.create :user}
  let(:invalid_post_params) {FactoryGirl.attributes_for :post}

  describe "GET #index" do
    it "returns http success" do
      get :index, domain_id: domain.slug
      expect(response).to have_http_status(302)
    end
  end

  describe "POST #create" do
    it "failed to create post" do
      sign_in user

      post(:create, {domain_id: domain.slug, post: invalid_post_params})
      expect(response).to redirect_to new_domain_ads_post_path
    end
  end
end
