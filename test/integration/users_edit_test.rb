require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    log_in_as @kylo
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

    assert_edit_failed(highlights: ['input@user_password'],
                       explanations:
                        ['Password is too short (minimum is 8 characters)'])
  end

  test 'edit can change email and name' do
    new_email = 'i_am_so_powerful@livejournal.com'
    new_name = 'Darth Ren'

    get edit_user_path(@kylo)
    assert_template 'users/edit'
    patch_via_redirect user_path(@kylo), user: { name: new_name,
                                                 email: new_email }
    assert_equal 'Changes saved.', flash[:success]
    assert_select '#user_name', new_name, 'should see new name'

    delete logout_path

    post login_path, session: { email: @kylo.email, password: 'password' }
    assert_template 'sessions/new', 'should be redirected to login page'
    assert_select '.alert-danger', 'Invalid email/password combination',
                  'old email should be rejected'

    post login_path, session: { email: new_email, password: 'password' }
    assert_redirected_to @kylo, 'should be redirected to the profile page'
  end

  test 'edit can change password' do
    new_password = 'f34rm3l0zr'

    get edit_user_path(@kylo)
    assert_template 'users/edit'
    patch_via_redirect user_path(@kylo),
                       user: { name: @kylo.name,
                               email: @kylo.email,
                               password: new_password,
                               password_confirmation: new_password }
    assert_equal 'Changes saved.', flash[:success]

    delete logout_path

    post login_path, session: { email: @kylo.email, password: 'password' }
    assert_template 'sessions/new', 'should be redirected to login page'
    assert_select '.alert-danger', 'Invalid email/password combination',
                  'old password should be rejected'

    post login_path, session: { email: @kylo.email, password: new_password }

    assert_redirected_to @kylo, 'should be redirected to the profile page'
  end
end
