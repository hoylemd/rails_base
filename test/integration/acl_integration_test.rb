require 'test_helper'

class AclIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    @peaches = users(:peaches)
    @parsecs = microposts(:parsecs)
  end

  test 'logged_in_user 401-renders to login page if user not logged in' do
    get users_path

    assert_401_not_logged_in
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

  test 'correct_user_or_go_home 401-renders home page if wrong user' do
    log_in_as @peaches
    delete micropost_path @parsecs

    assert_permission_denied
  end

  test 'correct_user_or_go_home passes if correct user' do
  end
end
