class PasswordResetsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: reset_email)

    if user
      user.create_password_reset_digest
      user.send_password_reset_email
    end

    # redirect to root with (potentially and intentionally misleading) flash
    show_password_reset_feedback user
    redirect_to root_path
  end

  def edit
  end

  private

  def show_password_reset_feedback(user)
    flash[:info] = 'A password reset link has been emailed to you'

    return unless Rails.env.development?
    if user
      user.reload
      reset_link = edit_password_reset_path user.reset_token
      flash[:info] += ". dev: <a href=\"#{reset_link}\">reset_link</a>"
    else
      flash[:info] += ". dev: No account for #{reset_email} found."
    end
  end

  def reset_email
    @reset_email ||= params[:password_reset][:email].downcase
  end
end
