require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: '', password: '' }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information' do
    get login_path
    post login_path, session: { email: @kylo.email, password: 'password' }
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
    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@kylo), count: 0
  end
end
