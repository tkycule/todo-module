require 'rails_helper'

RSpec.describe "V1::Sessions", :type => :request do

  describe "POST /v1/sessions" do

    context "パラメータが正しい時" do
      
      let(:user) { create(:user, password: "password") }

      before do 
        post "/v1/sessions", {email: user[:email], password: "password"}
      end

      it "201が返ってくる" do
        expect(response.status).to eq(201)
      end

      it "ユーザー情報が返ってくる" do
        expect(json["id"]).to eq(user[:id])
        expect(json["email"]).to eq(user[:email])
        expect(json["authentication_token"]).not_to be_nil
        expect(json.keys.length).to eq 3
      end
    end

    context "パラメータが正しくない時" do
      before do 
        post "/v1/sessions"
      end

      it "401が返ってくる" do
        expect(response.status).to eq(401)
      end
    end
  end
end
