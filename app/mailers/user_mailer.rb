class UserMailer < ApplicationMailer
  def email_verification(user)
    @user = user
    mail to: user.email, subject: 'Email verification'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @greeting = 'Hi'
    @user = user

    mail to: user.email, subject: 'Reset your password'
  end
end
