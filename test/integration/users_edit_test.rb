require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'edit with blank fields is rejected' do
    get edit_user_path(@kylo)
    assert_template 'users/edit'
    patch user_path(@kylo), user: { name: '',
                                    email: '',
                                    password: '',
                                    password_confirmation: '' }

    assert_template 'users/edit'

    assert_select 'li', 'Name can\'t be blank',
                  'Error messages should call out name'
    assert_select '.field_with_errors input#user_name', 1,
                  'Name field should be highlighted'

    assert_select 'li', 'Email can\'t be blank',
                  'Error messages should call out email'
    assert_select '.field_with_errors input#user_email', 1,
                  'Email field should be highlighted'

    assert_select 'li', 'Password is too short (minimum is 8 characters)',
                  'Error messages should call out password'
    assert_select '.field_with_errors input#user_password', 1,
                  'Password field should be highlighted'
  end

  test 'edit with invalid email is rejected' do
    get edit_user_path(@kylo)
    assert_template 'users/edit'
    patch user_path(@kylo), user: { name: @kylo.name,
                                    email: 'i am not an email address',
                                    password: 'password',
                                    password_confirmation: 'password' }

    assert_template 'users/edit'

    assert_select 'li', 'Email is invalid',
                  'Error messages should call out email'
    assert_select '.field_with_errors input#user_email', 1,
                  'Email field should be highlighted'
  end

  test 'edit with mismatched passwords is rejected' do
    get edit_user_path(@kylo)
    assert_template 'users/edit'
    patch user_path(@kylo), user: { name: @kylo.name,
                                    email: @kylo.email,
                                    password: 'password',
                                    password_confirmation: 'hunter22' }

    assert_template 'users/edit'

    assert_select 'li', 'Password confirmation doesn\'t match Password',
                  'Error messages should call out password'
    assert_select '.field_with_errors input#user_password_confirmation', 1,
                  'Password confirmation field should be highlighted'
  end

  test 'edit can change profile information' do
    new_email = 'i_am_so_powerful@livejournal.com'
    new_password = 'f34rm3l0zr'
    new_name = 'Darth Ren'

    get edit_user_path(@kylo)
    assert_template 'users/edit'
    patch_via_redirect user_path(@kylo),
                       user: { name: new_name,
                               email: new_email,
                               password: new_password,
                               password_confirmation: new_password }
    assert_equal 'Changes saved.', flash[:success]
    assert_select '#user_name', new_name, 'should see new name'

    delete logout_path

    post login_path, session: { email: @kylo.email, password: 'password' }
    assert_template 'sessions/new', 'should be redirected to login page'
    assert_select '.alert-danger', 'Invalid email/password combination',
                  'old credentials should be rejected'

    post login_path, session: { email: new_email, password: 'password' }
    assert_template 'sessions/new', 'should be redirected to login page'
    assert_select '.alert-danger', 'Invalid email/password combination',
                  'old password should be rejected'

    post login_path, session: { email: @kylo.email, password: new_password }
    assert_template 'sessions/new', 'should be redirected to login page'
    assert_select '.alert-danger', 'Invalid email/password combination',
                  'old email should be rejected'

    post login_path, session: { email: new_email, password: new_password }
    assert_redirected_to @kylo, 'should be redirected to the profile page'
  end
end
