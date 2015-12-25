require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App'
  end

  # TODO: 'should post create, valid'
  # TODO: 'should post create, invalid'
  # TODO: 'should get show, logged in'
  # TODO: 'should not get show, not logged in'
  # TODO: 'user_params strips out extra parameters'
end
