require 'rails_helper'

feature "Sessions", :type => :feature, js: true do

  let(:user) { create(:user, password: "password") }

  feature "ログイン" do

    context "非ログイン状態の時" do
      scenario "ログインできる" do
        login_user(user)

        expect(current_path).to eq tasks_path
        expect(page).to have_content "ログインしました。"
        within ".navbar" do
          expect(page).to have_content(user.email)
        end
      end
    end

    context "ログイン状態の時" do
      scenario "タスク一覧に飛ばされる" do
        login_user(user)
        visit root_path
        expect(current_path).to eq tasks_path
      end
    end

  end

  feature "ログアウト" do
    
    context "非ログイン状態の時" do

      scenario "ログアウトボタンは非表示" do
        visit root_path
        expect(page).not_to have_link("ログアウト")
      end
    end

    context "ログイン状態の時" do
      scenario "ログアウトできる" do
        login_user(user)
        find("#logout").click

        expect(current_path).to eq root_path
        expect(page).to have_content "ログアウトしました。"
        within ".navbar" do
          expect(page).not_to have_content(user.email)
        end
      end
    end

  end
end
