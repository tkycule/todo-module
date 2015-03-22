require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe "GET #new" do
    it "新しいUserを@userにセット" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it ":newテンプレートを表示" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "パラメータが正しい時" do

      let(:user) { create(:user, password: "password") }

      before do
        post :create, user: {email: user.email, password: "password"}
      end

      it "タスク一覧にリダイレクト" do
        expect(response).to redirect_to tasks_path
      end

      it "メッセージをセット" do
        expect(flash[:notice]).to eq "ログインしました。" 
      end 
    end

    context "パラメータが正しくない時" do
      
      before do
        post :create, user: {}
      end

      it ":newテンプレートを表示" do
        expect(response).to render_template :new
      end

      it "メッセージをセット" do
        expect(flash.now[:alert]).to eq "ログインに失敗しました。" 
      end 
    end
  end

  describe "DELETE #destroy" do
    
    before do
      login_user(create(:user))
      delete :destroy
    end

    it "トップページにリダイレクト" do
      expect(response).to redirect_to root_path
    end

    it "メッセージをセット" do
      expect(flash[:notice]).to eq "ログアウトしました。" 
    end 
  end

end
