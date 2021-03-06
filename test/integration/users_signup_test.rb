require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    @test_info = { name: 'Max Payne',
                   email: 'Max_Payne@example.com',
                   password: 'password',
                   password_confirmation: 'password' }
    @kylo = users(:kylo)
    ActionMailer::Base.deliveries.clear
  end

  test 'post to create should ignore extra parameters' do
    spec = { name: 'Luke Skywalker',
             email: 'the_last_jedi@example.com',
             password: 'password',
             password_confirmation: 'password',
             id: 'so lonely :(' }

    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: spec
    end

    assert_signup_succeeded spec
    # This tests user_params - the id field will be stripped out, and not cause
    # an error.  If it were not stripped out, an error would be raised because
    # ids are integers - not strings.
  end

  test 'post to create should ignore an admin parameter' do
    name = 'Finn'
    email = 'fn2817@firstorder.gal'

    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: { name: name,
                                            email: email,
                                            password: 'password',
                                            password_confirmation: 'password',
                                            admin: true }
    end

    assert_signup_succeeded
    assert_not User.find_by(email: email).admin, 'Should not be an admin'
  end

  test 'post with invalid email should error' do
    assert_no_difference 'User.count' do
      post users_path, user: @test_info.merge(email: '')
    end
    assert_response 422, 'should error on missing email'
    assert_signup_failed highlights: ['input#user_email'],
                         explanations: ['Email can\'t be blank',
                                        'Email is invalid']

    assert_no_difference 'User.count' do
      post users_path, user: @test_info.merge(email: 'i am not an email')
    end

    assert_response 422, 'should error on invalid email'
    assert_signup_failed highlights: ['input#user_email'],
                         explanations: ['Email is invalid']

    assert_no_difference 'User.count' do
      post users_path, user: @test_info.merge(email: @kylo.email)
    end
    assert_response 422, 'should error on already-taken email'
    assert_signup_failed highlights: ['input#user_email'],
                         explanations: ['Email has already been taken']
  end

  test 'post to create with invalid password or confirmation should error' do
    assert_no_difference 'User.count' do
      post users_path, user: @test_info.merge(password: '',
                                              password_confirmation: '')
    end
    assert_response 422, 'should error on missing password and confirmation'
    assert_signup_failed highlights: ['input#user_password'],
                         explanations: ['Password can\'t be blank']

    assert_no_difference 'User.count' do
      post users_path, user: @test_info.merge(password: 'short',
                                              password_confirmation: 'short')
    end
    assert_response 422, 'should error on too-short password'
    assert_signup_failed highlights: ['input#user_password'],
                         explanations: [
                           'Password is too short (minimum is 8 characters)']

    assert_no_difference 'User.count' do
      post users_path, user:
                       @test_info.merge(password: 'longbutwrong',
                                        password_confirmation: 'wrongandlong')
    end
    assert_response 422, 'should error on mismatched password and confirmation'
    assert_signup_failed highlights: ['input#user_password_confirmation'],
                         explanations: [
                           'Password confirmation doesn\'t match Password']
  end

  test 'get to invalid verification links should error' do
    spec = { name: 'Knives Chau',
             email: 'ihartsexbobomb4eva@rogellus.ca',
             password: 'password',
             password_confirmation: 'password' }

    post_via_redirect users_path, user: spec
    user = User.find_by(email: spec[:email])

    get edit_email_verification_path('invalid token')
    assert_not user.reload.verified?, 'User\'s email should not be validated'

    verify_token = get_user_verify_token user
    get edit_email_verification_path(verify_token, email: 'wrong')
    assert_not user.reload.verified?, 'User\'s email should not be validated'

    get edit_email_verification_path(verify_token, email: user.email)
    assert user.reload.verified?, 'User\'s email should be verified'
  end

  private

  def get_verify_emails_for(email)
    ActionMailer::Base.deliveries.select do |item|
      (item.to.include?(email) &&
       item.subject == 'Email verification')
    end
  end

  def get_user_verify_token(user)
    messages = get_verify_emails_for user.email
    get_token_from_email messages[-1]
  end

  def assert_signup_succeeded(spec = nil)
    assert_template 'users/show'

    assert_no_error_messages

    if spec
      flash = "Welcome, #{spec[:name]}! Please check your email to verify it"
    else
      flash = true
    end

    assert_flash type: 'success', expected: flash

    assert logged_in?, 'User should be logged in'

    return unless spec && spec[:email]
    messages = get_verify_emails_for spec[:email]
    assert_equal 1, messages.length,
                 'Should see exactly 1 Email verification sent to ' \
                   "#{spec[:email]}, saw #{messages.length}"
  end

  def assert_signup_failed(errors)
    assert_template 'users/new', 'Should be on signup page'

    unless errors[:flash]
      explanations = errors[:explanations].length
      noun = explanations == 1 ? 'error' : 'errors'
      errors[:flash] = "The form contains #{explanations} #{noun}."
    end

    assert_error_messages errors

    assert_not logged_in?, 'User should not be logged in'
  end
end
