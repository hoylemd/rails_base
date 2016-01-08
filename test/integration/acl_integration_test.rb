require 'test_helper'

class AclIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'logged_in_user redirects to login page if user not logged in' do
    get users_path

    assert_response :unauthorized, 'Should get a 401 UNAUTHORIZED status header'
    assert_template 'sessions/new', 'Should see the login page'
    assert_flash type: :danger, expected: 'Please log in first'
    assert_equal users_url, session[:forwarding_url],
                 'Should see the users path in the forwarding url'
  end

  test 'logged_in_user does not redirect if user logged in' do
    log_in_as @kylo
    get users_path

    assert_response :success, 'Should get 200 OK when logged in'
    assert_template 'users/index', 'Should see the users page'
    assert_flash false
  end
end
