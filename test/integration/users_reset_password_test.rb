require 'test_helper'

class UsersResetPasswordTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    @peaches = users(:peaches)
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

    token = get_token_from_email last_email
    assert token, 'Email should contain a token'

    get edit_password_reset_path token, email: @kylo.email
    assert_template 'password_resets/edit'

    payload = { user: { password: 'wordpass',
                        password_confirmation: 'wordpass' } }
    put_via_redirect password_reset_path(token, payload), email: @kylo.email

    assert_response :success, 'Password change should be accepted'
    assert_template 'users/show'
    assert_flash type: 'success', expected: 'Password has been reset'
    assert logged_in?, 'Should be logged in'

    delete logout_path
    log_in_as @kylo
    assert_not logged_in?, 'Should reject old password'
    assert_flash type: 'danger', expect: 'Invalid email/password combination'

    log_in_as @kylo, password: 'wordpass'
    assert logged_in?, 'Should accept new password'
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

  test 'get on edit redirects to home on invalid parameters' do
    get_via_redirect edit_password_reset_path 'sf', email: @kylo.email
    assert_template 'static_pages/home'
    assert_flash type: 'danger',
                 expected: 'Sorry, that password reset link is not valid'

    get_via_redirect edit_password_reset_path 'asdgejsHKDNH-23ddfJH6F',
                                              email: @kylo.email
    assert_template 'static_pages/home'
    assert_flash type: 'danger',
                 expected: 'Sorry, that password reset link is not valid'

    @kylo.create_password_reset_digest
    get_via_redirect edit_password_reset_path @kylo.reset_token, email: ''
    assert_template 'static_pages/home'
    assert_flash type: 'danger',
                 expected: 'Sorry, that password reset link is not valid'

    get_via_redirect edit_password_reset_path @kylo.reset_token,
                                              email: @peaches.email
    assert_template 'static_pages/home'
    assert_flash type: 'danger',
                 expected: 'Sorry, that password reset link is not valid'
  end

  test 'get on edit redirects to forgot password page on expired token' do
    @kylo.create_password_reset_digest
    @kylo.reset_sent_at = 3.hours.ago
    @kylo.save

    get_via_redirect edit_password_reset_path @kylo.reset_token,
                                              email: @kylo.email

    assert_template 'password_resets/new'
    assert_flash type: 'danger',
                 expected: 'Sorry, that password reset link has expired'
  end

  test 'post on update with invalid token redirects to home' do
    put_via_redirect password_reset_path('abcDEFghiJKL123pqrSTU-',
                                         email: @kylo.email),
                     user: {
                       password: 'wordpass',
                       password_confirmation: 'wordpass'
                     }
    assert_template 'static_pages/home'
    assert_error_messages flash: 'Sorry, that password reset link is not valid'

    @kylo.create_password_reset_digest

    put_via_redirect password_reset_path('abcDEFghiJKL123pqrSTU-',
                                         email: @kylo.email),
                     user: {
                       password: 'wordpass',
                       password_confirmation: 'wordpass'
                     }
    assert_template 'static_pages/home'
    assert_error_messages flash: 'Sorry, that password reset link is not valid'
  end

  test 'post on update with invalid email redirects to home' do
    @kylo.create_password_reset_digest
    put_via_redirect password_reset_path(@kylo.reset_token, email: 'no@no.ca'),
                     user: {
                       password: 'wordpass',
                       password_confirmation: 'wordpass'
                     }
    assert_template 'static_pages/home'
    assert_error_messages flash: 'Sorry, that password reset link is not valid'
  end

  test 'post on update on expired token redirects to home' do
    @kylo.create_password_reset_digest
    @kylo.reset_sent_at = 3.hours.ago
    @kylo.save

    put_via_redirect password_reset_path @kylo.reset_token,
                                         email: @kylo.email,
                                         user: {
                                           password: 'wordpass',
                                           password_confirmation: 'wordpass'
                                         }
    assert_template 'password_resets/new'
    assert_error_messages flash: 'Sorry, that password reset link has expired'
  end

  test 'post on update with blank passwords errors' do
    @kylo.create_password_reset_digest

    put_via_redirect password_reset_path(@kylo.reset_token, email: @kylo.email),
                     user: {
                       password: '',
                       password_confirmation: ''
                     }
    assert_template 'password_resets/edit'
    assert_error_messages flash: 'The form contains 1 error.',
                          explanations: ['Password can\'t be empty'],
                          highlights: ['input#user_password']
  end

  test 'post on update with too-short passwords errors' do
    @kylo.create_password_reset_digest

    put_via_redirect password_reset_path(@kylo.reset_token, email: @kylo.email),
                     user: {
                       password: 'pass',
                       password_confirmation: 'pass'
                     }
    assert_template 'password_resets/edit'
    assert_error_messages flash: 'The form contains 1 error.',
                          explanations: [
                            'Password is too short (minimum is 8 characters)'],
                          highlights: ['input#user_password']
  end
  test 'post on update with mismatched passwords errors' do
    @kylo.create_password_reset_digest

    put_via_redirect password_reset_path(@kylo.reset_token, email: @kylo.email),
                     user: {
                       password: 'wordpass',
                       password_confirmation: 'wordpasss'
                     }
    assert_template 'password_resets/edit'
    assert_error_messages flash: 'The form contains 1 error.',
                          explanations: [
                            'Password confirmation doesn\'t match Password'],
                          highlights: ['input#user_password_confirmation']
  end
end
