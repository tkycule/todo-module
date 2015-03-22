require 'rails_helper'

feature "Tasks", :type => :feature, js: true do

  context "ログイン状態の時" do

    let(:user) { create(:user) }
    
    background do
      login_user(user)
    end

    feature "タスク一覧" do
      
      background do
        create(:task, user: user, title: "Inbox Task")
        create(:task, user: user, title: "Completed Task").complete!
        create(:task, user: user, title: "Completed Task2").complete!
        create(:task, user: user, title: "Deleted Task").delete!
        create(:task, user: user, title: "Deleted Task2").delete!
        create(:task, user: user, title: "Deleted Task3").delete!
      end

      scenario "収集箱" do
        visit tasks_path
        expect(page).to have_css("#tasks li", count: 1)
        expect(page).to have_task_count(1, 2, 3)
        expect(page.find("#tasks li:first-child")).to have_text("Inbox Task")
      end

      scenario "完了" do
        visit completed_tasks_path
        expect(page).to have_css("#tasks li", count: 2)
        expect(page).to have_task_count(1, 2, 3)
        expect(page.find("#tasks li:first-child")).to have_text("Completed Task")
      end

      scenario "ゴミ箱" do
        visit deleted_tasks_path
        expect(page).to have_css("#tasks li", count: 3)
        expect(page).to have_task_count(1, 2, 3)
        expect(page.find("#tasks li:first-child")).to have_text("Deleted Task")
      end
    end

    feature "タスク操作" do
      
      scenario "タスクを追加する" do
        
        visit tasks_path

        expect(page).to have_css("#tasks li", count: 0)
        expect(page).to have_task_count(0, 0, 0)

        expect {
          find("#task_title").set("New Task")
          find("#new_task input[type=submit]").click
          wait_for_ajax
        }.to change(Task, :count).by(1)

        expect(page).to have_css("#tasks li", count: 1)
        expect(page.find("#tasks li:first-child")).to have_text("New Task")
        expect(page).to have_task_count(1, 0, 0)
        expect(page).to have_content("作成しました")
      end

      scenario "タスクを完了にする" do
        
        task = create(:task, user: user)
        visit tasks_path

        expect(page).to have_css("#tasks li", count: 1)
        expect(page).to have_task_count(1, 0, 0)

        within "#tasks li:first-child" do
          find(".task-complete").click
        end

        expect(current_path).to eq tasks_path

        expect(page).to have_css("#tasks li", count: 0)
        expect(page).to have_task_count(0, 1, 0)
        expect(page).to have_content("完了にしました。")

        task.reload
        expect(task).to be_completed
      end

      scenario "タスクを削除する" do
        
        task = create(:task, user: user)
        visit tasks_path

        expect(page).to have_css("#tasks li", count: 1)
        expect(page).to have_task_count(1, 0, 0)

        within "#tasks li:first-child" do
          find(".task-delete").click
        end

        expect(current_path).to eq tasks_path

        expect(page).to have_css("#tasks li", count: 0)
        expect(page).to have_task_count(0, 0, 1)
        expect(page).to have_content("ゴミ箱に入れました。")

        task.reload
        expect(task).to be_deleted
      end

      scenario "完了のタスクを戻す" do

        task = create(:task, user: user)
        task.complete!
        visit completed_tasks_path

        expect(page).to have_css("#tasks li", count: 1)
        expect(page).to have_task_count(0, 1, 0)
        
        within "#tasks li:first-child" do
          find(".task-revert").click
        end
        
        expect(current_path).to eq completed_tasks_path
        
        expect(page).to have_css("#tasks li", count: 0)
        expect(page).to have_task_count(1, 0, 0)
        expect(page).to have_content("収集箱に戻しました。")
        
        task.reload
        expect(task).to be_inbox
      end

      feature "タスク編集" do

        let!(:task) { create(:task, user: user) }

        background do
          visit tasks_path

          click_on task.title
          wait_for_ajax

          expect(current_path).to eq edit_task_path(task)
        end

        scenario "タイトルが入力されてる時、更新される" do
          find("#task_title").set("New Title")
          find(".edit_task input[type=submit]").click

          wait_for_ajax

          expect(current_path).to eq tasks_path
          expect(page.find("#tasks li:first-child")).to have_text("New Title")
          expect(page).to have_content("更新しました。")
        end

        scenario "タイトルが入力されてない時、更新されない" do
          find("#task_title").set("")
          find(".edit_task input[type=submit]").click

          wait_for_ajax

          expect(current_path).to eq edit_task_path(task)
          within ".form-group.task_title" do
            expect(page).to have_content "入力してください"
          end
        end

      end
    end
  end

  context "非ログイン状態の時" do
    scenario "ログインページに飛ばされる" do
      visit tasks_path
      expect(current_path).to eq root_path
    end
  end
end
