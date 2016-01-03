class UserMailer < ApplicationMailer
  def email_verification(user)
    @user = user
    mail to: user.email, subject: 'Email verification'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Reset your password'
  end
end
