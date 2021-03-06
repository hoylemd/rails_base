require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  def assert_edit_failed(errors)
    assert_template 'users/edit', 'Should be on the profile edit page'

    unless errors[:flash]
      explanations = errors[:explanations].length
      noun = explanations == 1 ? 'error' : 'errors'
      errors[:flash] = "The form contains #{explanations} #{noun}."
    end

    assert_error_messages errors
  end

  def assert_edit_succeeded
    assert_template 'users/show', 'Should be on profile page'

    assert_no_error_messages

    assert_flash type: 'success', expected: 'Changes saved.'
  end

  test 'edit with blank fields is rejected' do
    log_in_as @kylo
    patch_via_redirect user_path(@kylo),
                       user: { name: '',
                               email: '',
                               password: '',
                               password_confirmation: '' }

    assert_edit_failed(highlights: ['input#user_name',
                                    'input#user_email'],
                       explanations: ['Name can\'t be blank',
                                      'Email can\'t be blank',
                                      'Email is invalid'])
  end

  test 'edit with invalid email is rejected' do
    log_in_as @kylo
    patch user_path(@kylo), user: { name: @kylo.name,
                                    email: 'i am not an email address' }

    assert_edit_failed(highlights: ['input#user_email'],
                       explanations: ['Email is invalid'])
  end

  test 'edits with bad password changes are rejected' do
    log_in_as @kylo
    patch user_path(@kylo), user: { name: @kylo.name,
                                    email: @kylo.email,
                                    password: 'password',
                                    password_confirmation: 'hunter22' }

    assert_edit_failed(highlights: ['input#user_password_confirmation'],
                       explanations:
                        ['Password confirmation doesn\'t match Password'])

    patch user_path(@kylo), user: { name: @kylo.name,
                                    email: @kylo.email,
                                    password: 'short',
                                    password_confirmation: 'short' }

    assert_edit_failed(highlights: ['input#user_password'],
                       explanations:
                        ['Password is too short (minimum is 8 characters)'])
  end

  test 'edit can change email and name' do
    new_email = 'i_am_so_powerful@livejournal.com'
    new_name = 'Darth Ren'

    log_in_as @kylo
    patch_via_redirect user_path(@kylo), user: { name: new_name,
                                                 email: new_email }

    assert_edit_succeeded

    delete logout_path

    post login_path, session: { email: @kylo.email, password: 'password' }
    assert_template 'sessions/new', 'Should be redirected to login page'
    assert_flash type: 'danger', expected: 'Invalid email/password combination'

    post login_path, session: { email: new_email, password: 'password' }
    assert_redirected_to @kylo, 'Should be redirected to the profile page'
  end

  test 'edit can change password' do
    new_password = 'f34rm3l0zr'

    log_in_as @kylo
    patch_via_redirect user_path(@kylo),
                       user: { name: @kylo.name,
                               email: @kylo.email,
                               password: new_password,
                               password_confirmation: new_password }
    assert_edit_succeeded

    delete logout_path

    post login_path, session: { email: @kylo.email, password: 'password' }
    assert_template 'sessions/new', 'Should be redirected to login page'
    assert_flash type: 'danger', expected: 'Invalid email/password combination'

    post login_path, session: { email: @kylo.email, password: new_password }
    assert_redirected_to @kylo, 'should be redirected to the profile page'
  end

  test 'logging in after attempting unauthorized edit redirects to edit page' do
    get edit_user_path(@kylo)
    assert_template 'sessions/new', 'Should be redirected to login page'
    assert_equal session[:forwarding_url], edit_user_url(@kylo),
                 'Forwarding url is set to Kylo\'s edit page'
    log_in_as(@kylo)
    assert_redirected_to edit_user_path(@kylo)
    assert session[:forwarding_url].nil?, 'Forwarding url should be nil'
  end
end
