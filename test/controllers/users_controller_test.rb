require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App'
  end

  test 'should post create, valid' do
    post :create, user: { name: 'George Carlin',
                          email: 'george_carlin@example.com',
                          password: 'password',
                          password_confirmation: 'password' }
    assert_response :redirect, 'should redirect to user profile'
  end
  # TODO: 'should post create, invalid'
  # TODO: 'should get show, logged in'
  # TODO: 'should not get show, not logged in'
  # TODO: 'user_params strips out extra parameters'
end
