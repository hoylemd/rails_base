class EmailVerificationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.verified? &&
       user.authenticated?(:verification, params[:id])
      verify_email user
    else
      flash[:danger] = 'Invalid verification link'
      redirect_to root_url
    end
  end

  private

  def verify_email(user)
    user.verify_email
    log_in user
    flash[:success] = 'Email verified!'
    redirect_to user
  end
end
