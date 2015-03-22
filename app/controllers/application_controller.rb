class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :authenticate_user_from_token!
  before_filter :require_login

  private

  def authenticate_user_from_token!
    if token = request.headers["Authorization"]
      if @user = User.where(authentication_token: token).first
        auto_login(@user)
      end
    end
  end
  
  def not_authenticated
    if request[:format] == "json"
      head(401)
    else
      redirect_to root_path, alert: "ログインしてください。"
    end
  end
  
end

