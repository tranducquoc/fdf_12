require "rails_helper"

RSpec.describe SearchesController, type: :controller do
  let!(:user) {FactoryGirl.create :user}
  let!(:domain) {FactoryGirl.create :domain}
  let(:user_domain) do
    FactoryGirl.create :user_domain, user_id: user.id, domain_id: domain.id
  end

  describe "GET #index" do
    it "returns http success" do
      sign_in user

      get :index, domain_id: user_domain.domain.slug, search: Faker::Lorem.word
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #index" do
    it "cannot load domain" do
      sign_in user

      get :index, domain_id: nil, search: nil
      expect(response).to redirect_to root_path
    end
  end
end
