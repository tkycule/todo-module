class UsersController < ApplicationController

  skip_before_filter :require_login, only: [:new, :create]

  def new
    if session[:new_user_params].present?
      @user = User.new(session[:new_user_params])
      @user.valid?
      session.delete(:new_user_params)
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to tasks_path, notice: '登録しました。' 
    else
      flash[:alert] = "入力エラーがあります。"
      session[:new_user_params] = user_params
      redirect_to new_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
