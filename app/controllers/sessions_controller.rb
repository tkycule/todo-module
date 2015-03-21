class SessionsController < ApplicationController

  skip_before_filter :require_login, except: [:destroy]
  before_filter :skip_login, only: [:new]

  def new
    @user = User.new
  end

  def create
    if @user = login(params[:user][:email], params[:user][:password])
      redirect_back_or_to(tasks_path, notice: 'ログインしました。')
    else
      flash.now[:alert] = 'ログインに失敗しました。'
      @user = User.new
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(root_path, notice: 'ログアウトしました。')
  end

  private

  def skip_login
    if current_user
      redirect_to tasks_path
      return false
    end
  end

end
