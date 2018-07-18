require "rails_helper"

RSpec.describe IntroFeaturesController, type: :controller do
  let!(:user){FactoryGirl.create :user}
  before do
    sign_in user
  end

  context "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
