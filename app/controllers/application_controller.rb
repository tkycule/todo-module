class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :require_login

  private

  def not_authenticated
    redirect_to root_path, alert: "ログインしてください。"
  end
  
end
