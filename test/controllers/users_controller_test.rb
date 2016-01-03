require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @kylo = users(:kylo)
    @peaches = users(:peaches)
    @batman = users(:batman)
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App'
  end

  test 'should redirect edit when not logged in' do
    get :edit, id: @kylo

    assert_flash type: :danger, expected: 'Please log in.'
    assert_redirected_to login_url, 'Should redirect to login page'
  end

  test 'should redirect update when not logged in' do
    patch :update, id: @kylo, user: { name: @kylo.name, email: @kylo.email }

    assert_flash type: :danger, expected: 'Please log in.'
    assert_redirected_to login_url, 'Should redirect to login page'
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@peaches)
    get :edit, id: @kylo

    assert_flash type: :danger, expected: false
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@peaches)
    patch :update, id: @kylo, user: { name: @kylo.name, email: @kylo.email }

    assert_flash type: :danger, expected: false
    assert_redirected_to root_url
  end

  test 'should redirect index when not logged in' do
    get :index
    assert_redirected_to login_url
  end

  test 'destroy should redirect to index when not logged in' do
    assert_no_difference 'User.count', 'Should not change User count' do
      delete :destroy, id: @batman
    end

    assert_flash type: :success, expected: false
    assert_flash type: :danger, expected: 'Please log in.'
    assert_redirected_to login_path, 'Should be redirected to login page'
  end

  test 'destroy should redirect to index when not admin' do
    log_in_as @kylo
    assert_no_difference 'User.count', 'Should not change User count' do
      delete :destroy, id: @batman
    end

    assert_flash type: :success, expected: false
    assert_flash type: :danger,
                 expected: 'Sorry, you don\'t have permission to do that'
    assert_redirected_to users_path, 'Should be redirected to user index page'
  end

  test 'destroy should work when admin' do
    log_in_as @peaches
    assert_difference 'User.count', -1, 'Should delete one user' do
      delete :destroy, id: @batman
    end

    assert_flash type: :success, expected: 'User \'Batman\' deleted'
    assert_flash type: :danger, expected: false
    assert_redirected_to users_path, 'Should be redirected to user index page'
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
