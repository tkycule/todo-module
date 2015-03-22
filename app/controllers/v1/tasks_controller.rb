class V1::TasksController < V1::BaseController

  before_action :set_task, only: [:show, :update, :destroy, :complete, :revert]

  def index
    render json: current_user.tasks
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      render json: @task, status: 201
    else
      render json: @task.errors.full_messages, status: 422
    end
  end

  def show
    render json: @task
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors.full_messages, status: 422
    end
  end

  def complete
    @task.complete!
    render json: @task
  end

  def revert
    @task.revert!
    render json: @task
  end

  def destroy
    @task.delete!
    render json: @task
  end
  
  private

  def task_params
    params.require(:task).permit(:title, :memo)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end

