require 'rails_helper'

RSpec.describe Ads::PostsController, type: :controller do
  let(:domain) {Domain.create name: "Da Nang Office"}

  before :each do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    admin = FactoryGirl.create(:admin)
    sign_in admin
  end

  describe "GET #index" do
    it "returns http success" do
      get :index, domain_id: domain.slug
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "failed to create post" do
      post :create, domain_id: domain.slug
      expect(response).to redirect_to new_domain_ads_post_path
    end
  end
end
