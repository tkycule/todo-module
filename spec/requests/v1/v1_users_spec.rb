require 'rails_helper'

RSpec.describe "V1::Users", :type => :request do

  describe "POST /v1/users" do

    context "パラメーターが正しい時" do

      let(:user) { attributes_for(:user) }

      it "201が返ってくる" do
        post "/v1/users", user: user
        expect(response.status).to eq(201)
      end

      it "ユーザー情報が返ってくる" do
        post "/v1/users", user: user

        expect(json["id"]).not_to be_nil
        expect(json["email"]).to eq(user[:email])
        expect(json["authentication_token"]).not_to be_nil
        expect(json.keys.length).to eq 3
      end

      it "Userが生成されている" do
        expect {
          post "/v1/users", user: user
        }.to change(User, :count).by(1)
      end
    end

    context "パラメータが正しくない" do
      
      let(:user) { attributes_for(:user, email: "", password: "", password_confirmation: "") }

      it "422が返ってくる" do
        post "/v1/users", user: user
        expect(response.status).to eq(422)
      end

      it "エラーメッセージが返ってくる" do
        post "/v1/users", user: user
        expect(json).to include("メールアドレスを入力してください。")
        expect(json).to include("パスワードは8文字以上で入力してください。")
        expect(json).to include("パスワード(確認)を入力してください。")
      end

      it "Userが生成されていない" do
        expect {
          post "/v1/users", user: user
        }.not_to change(User, :count)
      end
    end

  end
end
