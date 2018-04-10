require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) {FactoryGirl.create :user}
  let(:valid_post) {FactoryGirl.create :post}
  let(:review_params) do
    FactoryGirl.create :review, user: user, reviewable: valid_post
  end

  describe "POST #create" do
    it "create successful" do
      post :create, review: review_params
      expect(response).to have_http_status(302)
    end
  end

  describe "PATCH #update" do
    it "should render new" do
      patch :update, review: review_params, id: review_params[:id]
      expect(response).to have_http_status(302)
    end
  end
end
