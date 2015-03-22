require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET #new" do
    it "新しいuserを@userにセット" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it ":newテンプレートを表示" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "有効な場合" do
      it "新しいuserを保存" do
        expect {
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it "tasks#indexにリダイレクト" do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to tasks_path
      end

      it "メッセージをセット" do
        post :create, user: attributes_for(:user)
        expect(flash[:notice]).to eq "登録しました。" 
      end 
    end

    context "無効な場合" do
      it "userを保存しない" do
        expect {
          post :create, user: attributes_for(:invalid_user)
        }.not_to change(Task, :count)
      end

      it "users#newにリダイレクト" do
        post :create, user: attributes_for(:invalid_user)
        expect(response).to redirect_to new_user_path
      end

      it "メッセージをセット" do
        post :create, user: attributes_for(:invalid_user)
        expect(flash.now[:alert]).to eq "入力エラーがあります。" 
      end 
    end
  end

end
