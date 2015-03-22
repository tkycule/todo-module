class V1::SessionsController < V1::BaseController

  skip_before_filter :require_login

  def create
    if @user = login(params[:email], params[:password])
      render status: 201, json: @user.to_json(only: [:id, :email, :authentication_token])
    else
      head(401)
    end
  end

end

