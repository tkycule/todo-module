require 'rails_helper'

RSpec.describe ApplicationHelper, :type => :helper do

  describe "#bootstrap_class_for" do
    it "適切なclassを返す" do
      expect(helper.bootstrap_class_for(:success)).to eq("alert-success") 
      expect(helper.bootstrap_class_for(:error)).to eq("alert-danger") 
      expect(helper.bootstrap_class_for(:alert)).to eq("alert-warning") 
      expect(helper.bootstrap_class_for(:notice)).to eq("alert-info") 
      expect(helper.bootstrap_class_for(:other)).to eq("other") 
    end 
  end
end
