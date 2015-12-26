require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test_user = { name: 'Max Payne',
                email: 'Max_Payne@example.com',
                password: 'password',
                password_confirmation: 'password' }

  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App'
  end

  test 'should redirect on post to create with valid information' do
    post :create, user: { name: 'George Carlin',
                          email: 'george_carlin@example.com',
                          password: 'password',
                          password_confirmation: 'password' }
    assert_response :redirect, 'should redirect to user profile'
  end

  test 'should error on post with missing name' do
    post :create, user: test_user.merge(name: '')
    assert_response 422, 'should error on missing name'
    assert_select '.field_with_errors input#user_name', 1,
                  'name field should be highlighted'
  end

  test 'should post create, invalid' do
    post :create, user: test_user.merge(email: '')
    assert_response 422, 'should error on missing email'

    post :create, user: test_user.merge(password: '', password_confirmation: '')
    assert_response 422, 'should error on missing password and confirmation'

    post :create, user: test_user.merge(password: 'longbutwrong',
                                        password_confirmation: 'wrongandlong')
    assert_response 422, 'should error on mismatched password and confirmation'

    post :create, user: test_user.merge(password: 'short',
                                        password_confirmation: 'short')
    assert_response 422, 'should error on too-short password'

    post :create, user: test_user.merge(email: 'vader_fan667@hotmail.com')
    assert_response 422, 'should error on already-taken password'
  end

  # TODO: 'should get show, logged in'
  # TODO: 'should not get show, not logged in'
  # TODO: 'user_params strips out extra parameters'
end
