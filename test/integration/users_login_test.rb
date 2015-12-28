require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @peaches = users(:peaches)
    @kylo = users(:kylo)
    @nobody = User.new(email: '')
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    log_in_as @nobody, password: ''
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information' do
    get login_path
    log_in_as @kylo
    assert logged_in?
    assert_redirected_to @kylo
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@kylo)
    delete logout_path
    assert_not logged_in?
    assert_redirected_to login_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@kylo), count: 0
  end

  test 'login with remembering' do
    log_in_as(@kylo, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test 'login without remembering' do
    log_in_as(@kylo, remember_me: '0')
    assert_nil cookies['remember_token']
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@peaches)
    get users_path
    assert_no_error_messages
    assert_select 'div.pagination', 2, 'Should see both pagination controls'
    # it's 29 because one is the current user, so it doesn't have a delete link
    assert_select '.users li a', { text: 'delete', count: 29 },
                  'Should see 30 delete links'
  end

  test 'index as non-admin' do
    log_in_as @kylo
    get users_path
    assert_no_error_messages
    assert_select '.users li a', { text: 'delete', count: 0 },
                  'Should not see any delete links'
    assert_select '.users li', 30, 'Should see 30 users'
  end
end
