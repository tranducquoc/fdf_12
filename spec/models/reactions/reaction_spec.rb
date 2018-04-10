require "rails_helper"

RSpec.describe Reaction, type: :model do
  let(:user) {FactoryGirl.create :user}
  let(:review) {FactoryGirl.create :review}
  let(:reaction) {FactoryGirl.create :reaction, user: user, reactionable: review}
  subject {reaction}

  context "Associations" do
    it {is_expected.to belong_to :user}
  end

  describe "validates" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
  end
end
