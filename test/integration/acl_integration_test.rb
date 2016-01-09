require 'test_helper'

class AclIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    @batman = users(:batman)
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
  end

  test 'correct_user_or_render_401 401-renders home page if wrong user' do
    log_in_as @batman
    delete micropost_path @parsecs

    assert_permission_denied
  end

  test 'correct_user_or_render_401 passes if correct user' do
    log_in_as @kylo
    delete micropost_path @parsecs

    assert_redirected_to root_path, 'Should redirect to root'
  end

  test 'correct_user_or_render_401 passes if admin user' do
    log_in_as @peaches
    delete micropost_path @parsecs

    assert_redirected_to root_path, 'Should redirect to root'
  end
end
