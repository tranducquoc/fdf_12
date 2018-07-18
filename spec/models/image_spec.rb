require "rails_helper"

RSpec.describe Image, type: :model do
  let(:image) {FactoryGirl.create :image}

  describe "Post" do
    it {should have_many :post_images}
    it {should have_many(:posts).through(:post_images)}
  end

  describe "validates" do
    context "image" do
      it "is valid" do
        is_expected.to be_valid
      end
    end
  end
end
