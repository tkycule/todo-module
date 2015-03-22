require 'rails_helper'

RSpec.describe TasksController, :type => :controller do

  context "ログイン状態の時" do

    before do
      @user = create(:user)
      login_user(@user)
    end

    describe "リスト系ページ" do

      before do
        @task1 = create(:task, title: "task1", user: @user)
        @task2 = create(:task, title: "task2", user: @user)
      end
      
      describe "GET #index" do
        it "inboxのタスクを@tasksにセット" do
          get :index
          expect(assigns(:tasks)).to eq([@task2, @task1])
        end

        it ":indexテンプレートを表示" do
          get :index
          expect(response).to render_template :index
        end
      end

      describe "GET #completed" do
        it "completedのタスクを@tasksにセット" do
          @task1.complete!
          get :completed
          expect(assigns(:tasks)).to eq([@task1])
        end

        it ":indexテンプレートを表示" do
          get :completed
          expect(response).to render_template :index
        end
      end

      describe "GET #deleted" do
        it "deletedのタスクを@tasksにセット" do
          @task1.delete!
          get :deleted
          expect(assigns(:tasks)).to eq([@task1])
        end

        it ":indexテンプレートを表示" do
          get :deleted
          expect(response).to render_template :index
        end
      end
    end

    describe "GET #edit" do
      before do
        @task = create(:task, user: @user)
        get :edit, id: @task
      end

      it "要求されたtaskを@taskにセット" do
        expect(assigns(:task)).to eq @task
      end

      it ":editテンプレートを表示" do
        expect(response).to render_template :edit
      end
    end

    describe "POST #create" do
      context "有効な場合" do
        it "新しいtaskを保存" do
          expect {
            post :create, task: attributes_for(:task)
          }.to change(Task, :count).by(1)
        end

        it "tasks#indexにリダイレクト" do
          post :create, task: attributes_for(:task)
          expect(response).to redirect_to tasks_path
        end

        it "メッセージをセット" do
          post :create, task: attributes_for(:task)
          expect(flash[:notice]).to eq "作成しました。" 
        end 
      end

      context "無効な場合" do
        it "taskを保存しない" do
          expect {
            post :create, task: attributes_for(:invalid_task)
          }.not_to change(Task, :count)
        end

        it ":newテンプレートを表示" do
          post :create, task: attributes_for(:invalid_task)
          expect(response).to redirect_to tasks_path
        end

        it "メッセージをセット" do
          post :create, task: attributes_for(:invalid_task)
          expect(flash[:alert]).to eq "入力してください。" 
        end 
      end
    end

    describe "PATCH #update" do
      before do
        @task = create(:task, title: "task", user: @user)
      end

      context "有効な場合" do
        before do
          patch :update, id: @task, task: attributes_for(:task, title: "updated task")
        end

        it "taskを更新" do
          @task.reload
          expect(@task.title).to eq("updated task")
        end
        
        it "tasks#indexにリダイレクト" do
          expect(response).to redirect_to tasks_path
        end

        it "メッセージをセット" do
          expect(flash[:notice]).to eq "更新しました。" 
        end 
      end

      context "無効な場合" do
        before do
          patch :update, id: @task, task: attributes_for(:task, title: nil)
        end

        it "taskを更新しない" do
          @task.reload
          expect(@task.title).not_to be_nil
        end

        it "tasks/:id/editにリダイレクト" do
          expect(response).to redirect_to edit_task_path(@task)
        end

        it "メッセージをセット" do
          expect(flash[:alert]).to eq "入力エラーがあります。" 
        end 
      end
    end

    describe "DELETE #destroy" do
      before do
        request.env["HTTP_REFERER"] = tasks_path
        @task = create(:task, title: "task", user: @user)
        delete :destroy, id: @task
      end

      it "taskの状態をdeletedに" do
        @task.reload
        expect(@task).to be_deleted
      end

      it "前のページにリダイレクト" do
        expect(response).to redirect_to tasks_path
      end

      it "メッセージをセット" do
        expect(flash[:notice]).to eq "ゴミ箱に入れました。" 
      end 
    end

    describe "PATCH #complete" do
      before do
        request.env["HTTP_REFERER"] = tasks_path
        @task = create(:task, title: "task", user: @user)
        patch :complete, id: @task
      end

      it "taskの状態をcompletedに" do
        @task.reload
        expect(@task).to be_completed
      end

      it "前のページにリダイレクト" do
        expect(response).to redirect_to tasks_path
      end

      it "メッセージをセット" do
        expect(flash[:notice]).to eq "完了にしました。" 
      end 
    end

    describe "PATCH #revert" do
      before do
        request.env["HTTP_REFERER"] = tasks_path
        @task = create(:task, title: "task", user: @user)
        patch :revert, id: @task
      end

      it "taskの状態をinboxに" do
        @task.reload
        expect(@task).to be_inbox
      end

      it "前のページにリダイレクト" do
        expect(response).to redirect_to tasks_path
      end

      it "メッセージをセット" do
        expect(flash[:notice]).to eq "収集箱に戻しました。" 
      end 
    end
  end

  context "非ログイン状態の時" do
    describe "GET #index" do
      it "ログインページに飛ばす" do
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eq "ログインしてください。" 
      end
    end
  end

end
