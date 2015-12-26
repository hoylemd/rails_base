require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @test_info = { name: 'Max Payne',
                   email: 'Max_Payne@example.com',
                   password: 'password',
                   password_confirmation: 'password' }
    @kylo = users(:kylo)
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App'
  end

  # TODO: These should be moved to integration tests
  test 'should redirect on post to create with valid information' do
    post :create, user: { name: 'George Carlin',
                          email: 'george_carlin@example.com',
                          password: 'password',
                          password_confirmation: 'password' }
    assert_response :redirect, 'should redirect to user profile'

    post :create, user: { name: 'Luke Skywlker',
                          email: 'the_last_jedi@example.com',
                          password: 'password',
                          password_confirmation: 'password',
                          id: 'so lonely :(' }
    assert_response :redirect, 'should ignore extra parameters'
    # This tests user_params - the id field will be stripped out, and not cause
    # an error.  if it were not stripped out, an error would be raised, as ids
    # are integers, not strings
  end

  test 'should error on post with missing name' do
    post :create, user: @test_info.merge(name: '')
    assert_response 422, 'should error on missing name'
    assert_select '.field_with_errors input#user_name', 1,
                  'name field should be highlighted'
  end

  test 'should error on post with invalid email' do
    post :create, user: @test_info.merge(email: '')
    assert_response 422, 'should error on missing email'
    assert_select '.field_with_errors input#user_email', 1,
                  'email field should be highlighted'

    post :create, user: @test_info.merge(email: 'i am not an email address')
    assert_response 422, 'should error on invalid email'
    assert_select '.field_with_errors input#user_email', 1,
                  'email field should be highlighted'

    post :create, user: @test_info.merge(email: @kylo.email)
    assert_response 422, 'should error on already-taken password'
    assert_select '.field_with_errors input#user_email', 1,
                  'email field should be highlighted'
  end

  test 'should error on post with invalid password or confirmation' do
    post :create, user: @test_info.merge(password: '',
                                         password_confirmation: '')
    assert_response 422, 'should error on missing password and confirmation'
    assert_select '.field_with_errors input#user_password', 1,
                  'should highlight password field'

    post :create, user: @test_info.merge(password: 'short',
                                         password_confirmation: 'short')
    assert_response 422, 'should error on too-short password'
    assert_select '.field_with_errors input#user_password', 1,
                  'should highlight password field'

    post :create, user: @test_info.merge(password: 'longbutwrong',
                                         password_confirmation: 'wrongandlong')
    assert_response 422, 'should error on mismatched password and confirmation'
    assert_select '.field_with_errors input#user_password_confirmation', 1,
                  'should highlight password confirmation field'
  end

  # I can't figure out how to go the GET here. Keeps saying:
  # ActionController::UrlGenerationError Exception: No route matches
  #   {:action=>"/users/33989797", :controller=>"users"}
  # test 'should get show' do
  #   get user_path(id: @kylo.id)
  #   assert_response :success, 'should return 200 OK'
  #   assert_select 'title', 'Kylo Ren | Ruby on Rails Tutorial Sample App'
  # end
end
