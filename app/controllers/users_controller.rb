class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_verification_email
      flash[:info] = 'Please check your email to verify your email.'
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
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

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user_is @user
  end

  # Confirms admins only
  def admin_user
    return if current_user.admin?

    flash[:danger] = 'Sorry, you don\'t have permission to do that.'
    redirect_to users_path
  end
end
