require 'rails_helper'

RSpec.describe "V1::Tasks", :type => :request do

  context "ログイン状態の時" do

    let(:user) { create(:user) }

    describe "GET /v1/tasks" do

      before do
        create(:task, user: user)
        create(:task, user: user)
        create(:task, user: user)
        auth_get user, "/v1/tasks"
      end

      it "200が返ってくる" do
        expect(response.status).to eq(200)
      end

      it "タスクが返ってくる" do
        expect(json.length).to eq(user.tasks.length)
      end
    end

    describe "GET /v1/tasks/:id" do

      let(:task) { create(:task, user: user) }

      before do
        auth_get user, "/v1/tasks/#{task.id}"
      end

      it "200が返ってくる" do
        expect(response.status).to eq(200)
      end

      it "タスクが返ってくる" do
        expect(json["title"]).to eq(task.title)
      end
    end

    describe "POST /v1/tasks" do

      context "パラメータが正しい時" do

        let(:title) { "New Task" }

        it "201が返ってくる" do
          auth_post user, "/v1/tasks", {task: {title: title}}
          expect(response.status).to eq(201)
        end

        it "タスクが返ってくる" do
          auth_post user, "/v1/tasks", {task: {title: title}}
          expect(json["title"]).to eq(title)
        end

        it "Taskが作られている" do
          expect {
            auth_post user, "/v1/tasks", {task: {title: title}}
          }.to change(Task, :count).by(1)
        end
      end

      context "パラメータが正しくない時" do
        
        it "422が返ってくる" do
          auth_post user, "/v1/tasks", {task: {title: ""}}
          expect(response.status).to eq(422)
        end

        it "エラーメッセージが返ってくる" do
          auth_post user, "/v1/tasks", {task: {title: ""}}
          expect(json).to include("タイトルを入力してください。")
        end

        it "Taskが作られていない" do
          expect {
            auth_post user, "/v1/tasks", {task: {title: ""}}
          }.not_to change(Task, :count)
        end
      end
    end

    describe "PATCH /v1/tasks/:id/complete" do
      
      let(:task) { create(:task, user: user) }

      before do
        auth_patch user, "/v1/tasks/#{task.id}/complete"
      end

      it "200が返ってくる" do
        expect(response.status).to eq(200)
      end

      it "aasm_stateがcompletedになっている" do
        expect(json["aasm_state"]).to eq("completed")

        task.reload
        expect(task).to be_completed
      end
    end

    describe "DELETE /v1/tasks/:id" do
      
      let(:task) { create(:task, user: user) }

      before do
        auth_delete user, "/v1/tasks/#{task.id}"
      end

      it "200が返ってくる" do
        expect(response.status).to eq(200)
      end

      it "aasm_stateがdeletedになっている" do
        expect(json["aasm_state"]).to eq("deleted")

        task.reload
        expect(task).to be_deleted
      end
    end

    describe "PATCH /v1/tasks/:id/revert" do
      
      let(:task) { create(:task, user: user) }

      before do
        task.complete!
        auth_patch user, "/v1/tasks/#{task.id}/revert"
      end

      it "200が返ってくる" do
        expect(response.status).to eq(200)
      end

      it "aasm_stateがinboxになっている" do
        expect(json["aasm_state"]).to eq("inbox")

        task.reload
        expect(task).to be_inbox
      end
    end

    describe "PATCH /v1/tasks/:id" do

      let(:task) { create(:task, user: user) }

      context "パラメーターが正しい時" do

        let(:title) { "New Title" }

        before do
          auth_patch user, "/v1/tasks/#{task.id}", {task: {title: title}}
        end

        it "200が返ってくる" do
          expect(response.status).to eq(200)
        end

        it "titleが更新されている" do
          expect(json["title"]).to eq(title)

          task.reload
          expect(task.title).to eq(title)
        end
      end

      context "パラメーターが正しくない時" do

        before do
          auth_patch user, "/v1/tasks/#{task.id}", task: {title: ""}
        end

        it "422が返ってくる" do
          expect(response.status).to eq(422)
        end

        it "エラーメッセージが返ってくる" do
          expect(json).to include("タイトルを入力してください。")
        end

        it "titleが更新されていない" do
          task.reload
          expect(task.title).not_to eq("")
        end
      end
    end
  end

  context "非ログイン状態の時" do
    describe "GET /v1/tasks" do

      let(:user) { create(:user) }

      before do
        user.authentication_token = "wrong_key"
        auth_get user, "/v1/tasks"
      end

      it "401が返ってくる" do
        expect(response.status).to eq(401)
      end
    end
  end
end
