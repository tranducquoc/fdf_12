require "rails_helper"

RSpec.describe Admin::ReportsController , type: :controller do
  let(:report) {FactoryGirl.create :report}

  before do
    admin = FactoryGirl.create :admin
    sign_in admin
  end

  describe "GET #index" do
    it "should index all reports" do
      get :index
      expect(response).to render_template "index"
    end
  end
end
