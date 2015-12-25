require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
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
    assert_not_nil cookies['remember_token']
  end

  test 'login without remembering' do
    log_in_as(@kylo, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
