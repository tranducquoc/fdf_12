require "rails_helper"

RSpec.describe PostImage, type: :model do
  let(:image) {FactoryGirl.create :image}
  let(:post) {FactoryGirl.create :post}
  let(:post_image) {FactoryGirl.create :post_image}

  describe "associations" do
    it {is_expected.to belong_to :image}
    it {is_expected.to belong_to :post}
  end
end
