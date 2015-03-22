require 'rails_helper'

RSpec.describe User, :type => :model do

  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it { should have_many(:tasks) }

  describe "validations" do

    it { should validate_presence_of(:email) }
    it { should validate_confirmation_of(:password) }
    it { should validate_presence_of(:password_confirmation) }

    describe "uniqueness" do
      subject { create(:user) }
      it { should validate_uniqueness_of(:email) }
    end
  end

  describe "作成した時、tokenがセットされる" do
    subject { create(:user) }
    its(:authentication_token) { is_expected.not_to be_empty }
  end

  describe "#reset_authentication_token!" do
    before do
      @user = create(:user)
      @old_token = @user.authentication_token
      @user.reset_authentication_token!
    end

    subject { @user }
    its(:authentication_token) { is_expected.not_to be eq @old_token}
  end

end
