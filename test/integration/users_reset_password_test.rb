require 'test_helper'

class UsersResetPasswordTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    ActionMailer::Base.deliveries.clear
  end

  test 'main reset flow' do
    get new_password_reset_path

    assert_template 'password_resets/new', 'Should be on reset password page'

    post_via_redirect password_resets_path,
                      password_reset: { email: @kylo.email }

    assert_template 'static_pages/home', 'Should be on home page'

    assert_flash type: :info,
                 expect: 'A password reset link has been emailed to you'

    last_email = ActionMailer::Base.deliveries[-1]
    assert_equal @kylo.email, last_email.to[0],
                 "Should have sent an email to '#{@kylo.email}'"
    assert_equal 'Reset your password', last_email.subject,
                 "Should have sent an email with 'Reset your password' subject"
  end

  test 'unknown email behaves the same as known email' do
    post_via_redirect password_resets_path,
                      password_reset: { email: 'fake@notemail.bla' }

    assert_template 'static_pages/home', 'Should be on home page'

    assert_flash type: :info,
                 expect: 'A password reset link has been emailed to you'

    assert_equal 0, ActionMailer::Base.deliveries.length,
                 'Should not have sent an email'
  end
end
