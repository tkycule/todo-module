require 'rails_helper'

feature "Users", :type => :feature, js: true do

  given(:user) { build(:user) }

  background do
    visit logout_path
    visit new_user_path
    expect(find("h1")).to have_content("新規登録")
  end

  scenario "新規登録できる" do
    expect{
      find("#user_email").set user.email
      find("#user_password").set user.password
      find("#user_password_confirmation").set user.password_confirmation
      find("form#new_user input[type=submit]").click
      wait_for_ajax
    }.to change(User, :count).by(1)

    expect(current_path).to eq tasks_path
  end

  scenario "エラーメッセージが表示される" do
    expect{
      find("form#new_user input[type=submit]").click
    }.not_to change(User, :count)

    within ".form-group.user_email" do
      expect(page).to have_content "入力してください"
    end

    within ".form-group.user_password" do
      expect(page).to have_content "入力してください"
    end

    within ".form-group.user_password_confirmation" do
      expect(page).to have_content "入力してください"
    end

    expect(current_path).to eq new_user_path
  end

end
