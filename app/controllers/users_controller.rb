class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  before_action :user_show_acl,  only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_verification_email
      show_signup_feedback @user
      log_in @user
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    if current_user.verified?
      if @current_user.admin?
        @users = User.paginate(page: params[:page])
      else
        # only show verified users to non-admins
        @users = User.where(verified: true).paginate(page: params[:page])
      end
    else
      permission_denied
    end
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Changes saved.'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])
    name = user.name
    user.destroy

    flash[:success] = "User '#{name}' deleted"

    redirect_to users_url
  end

  private

  def show_signup_feedback(user)
    message = "Welcome, #{user.name}! Please check your email to verify it"
    if Rails.env.development?
      verify_link = edit_email_verification_path(user.verification_token,
                                                 email: user.email)
      message += ". <a href=\"#{verify_link}\">dev verify</a>"
    end
    flash[:success] = message
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user_is @user
  end

  def permission_denied
    flash[:danger] = 'Sorry, you don\'t have permission to do that'
    redirect_to(@current_user.verified? ? users_path : root_path)
  end

  # Confirms admins only
  def admin_user
    permission_denied unless current_user.admin?
  end

  def user_show_acl
    @user = User.find(params[:id])
    return if @user && (
      @user.verified? || current_user.admin? || @user == current_user)

    flash[:danger] = "Sorry, user '#{params[:id]}' does not exist"
    redirect_to users_path
  end
end
