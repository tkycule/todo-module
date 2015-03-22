class V1::UsersController < V1::BaseController

  skip_before_filter :require_login, only: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      render status: 201, json: @user.to_json(only: [:id, :email, :authentication_token])
    else
      render :json => @user.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
end
