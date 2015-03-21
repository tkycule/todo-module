class TasksController < ApplicationController

  before_action :set_count, only: [:index, :completed, :deleted]
  before_action :set_task, only: [:edit, :update, :destroy, :complete, :revert]
  before_action :set_new_task, only: [:index, :completed, :deleted]

  def index
    @tasks = current_user.tasks.inbox.order("id desc")
  end

  def completed
    @tasks = current_user.tasks.completed.order("id desc")
    render :index
  end

  def deleted
    @tasks = current_user.tasks.deleted.order("id desc")
    render :index
  end

  def edit
    if session[:task_params]
      @task.attributes = session[:task_params]
      @task.valid?
      session.delete(:task_params)
    end
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      redirect_to tasks_path, notice: '作成しました。'
    else
      redirect_to tasks_path, alert: "入力してください。"
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: '更新しました。' 
    else
      flash[:alert] = '入力エラーがあります。'
      session[:task_params] = task_params
      redirect_to edit_task_path
    end
  end

  def destroy
    @task.delete!
    redirect_to :back, notice: 'ゴミ箱に入れました。'
  end

  def complete
    @task.complete!
    redirect_to :back, notice: "完了にしました。"
  end

  def revert
    @task.revert!
    redirect_to :back, notice: "収集箱に戻しました。"
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :memo)
  end

  def set_new_task 
    @new_task = Task.new
  end

  def set_count
    @inbox_count = current_user.tasks.inbox.count
    @completed_count = current_user.tasks.completed.count
    @deleted_count = current_user.tasks.deleted.count
  end
end
