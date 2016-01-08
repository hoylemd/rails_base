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
  end
end
