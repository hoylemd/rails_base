require 'test_helper'

class AclIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    @parsecs = microposts(:parsecs)
  end

  test 'logged_in_user 401-renders to login page if user not logged in' do
    get users_path

    assert_response :unauthorized, 'Should get a 401 UNAUTHORIZED status header'
    assert_template 'sessions/new', 'Should see the login page'
    assert_flash type: :danger, expected: 'Please log in first'
    assert_equal users_url, session[:forwarding_url],
                 'Should see the users path in the forwarding url'
  end

  test 'logged_in_user passes if user logged in' do
    log_in_as @kylo
    get users_path

    assert_response :success, 'Should get 200 OK when logged in'
    assert_template 'users/index', 'Should see the users page'
    assert_flash false
  end

  test 'correct_user_or_go_home 401-renders login page if not logged in' do
    delete micropost_path @parsecs

    assert_response :unauthorized, 'Should get a 401 UNAUTHORIZED status header'
    assert_template 'sessions/new', 'Should see the login page'
    assert_flash type: :danger, expected: 'Please log in first'
  end

  test 'correct_user_or_go_home 401-renders home page if wrong user' do
  end

  test 'correct_user_or_go_home passes if correct user' do
  end
end
