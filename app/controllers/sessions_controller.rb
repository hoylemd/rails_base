class SessionsController < ApplicationController
  def new
  end

  def create
    parsed_params = login_params
    @user = User.find_by(email: parsed_params[:email])
    if @user && @user.authenticate(parsed_params[:password])
      log_in @user, parsed_params[:remember_me]
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unauthorized
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

  def login_params
    raw = params.require(:session).permit(:email, :password, :remember_me)
    raw[:email].downcase!
    raw[:remember_me] = raw[:remember_me] == '1' ? true : false
    raw
  end
end
