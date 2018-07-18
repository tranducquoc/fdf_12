require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do

  let!(:post ) { FactoryGirl.create :post }

  before do
    admin = FactoryGirl.create :admin
    sign_in admin
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "PATCH #update" do
    it "returns http status code 302 - redirect" do
      patch :update, params: {id: post.id}, format: :js
      expect(response).to have_http_status "302"
    end

    it "returns http success when approve" do
      patch :update, params: {id: post.id, approve_flag: true}, format: :js
      expect(response).to be_success
    end

    it "returns http success when reject" do
      patch :update, params: {id: post.id, reject_flag: true}, format: :js
      expect(response).to be_success
    end
  end

  describe "PATCH #update" do
    it "updated status to approved" do
      patch :update, params: {id: post.id, approve_flag: true}, format: :js
      expect(post.reload.status).to eq("approved")
    end

    it "updated status to rejected" do
      patch :update, params: {id: post.id, reject_flag: true}, format: :js
      expect(post.reload.status).to eq("rejected")
    end
  end

end
