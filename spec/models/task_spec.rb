require 'rails_helper'

RSpec.describe Task, :type => :model do

  it "has a valid factory" do
    expect(build(:task)).to be_valid
  end

  it { should belong_to(:user) }

  describe "validations" do
    subject { create(:task) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:user_id) }
  end

  describe "aasm" do

    subject { build(:task) }

    context "initial" do
      its(:aasm_state) { is_expected.to eq "inbox" }
    end

    context "#complete!" do
      before { subject.complete! }
      its(:aasm_state) { is_expected.to eq "completed" }
    end

    context "#delete!" do
      before { subject.delete! }
      its(:aasm_state) { is_expected.to eq "deleted" }
    end

    context "#revert!" do
      before do
        subject.complete!
        subject.revert!
      end 
      its(:aasm_state) { is_expected.to eq "inbox" }
    end

  end

end
