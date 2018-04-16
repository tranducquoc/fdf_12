require "rails_helper"

RSpec.describe Report, type: :model do
  let(:report) {FactoryGirl.create :report}
  subject {report}

  describe "associations" do
    it {is_expected.to belong_to :user}
    it {is_expected.to belong_to :post}
  end

  describe "validates" do
    context "content" do
      it "is valid" do
        is_expected.to be_valid
      end
    end

    context "content" do
      before {report.content = ""}
      it "is invalid" do
        is_expected.to_not be_valid
      end
    end
  end
end
