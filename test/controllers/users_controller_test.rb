require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @kylo = users(:kylo)
    @peaches = users(:peaches)
    @batman = users(:batman)
  end

  test 'get to new displays the signup page' do
    get :new
    assert_response :success, 'Should receive 200 OK on GET to new'
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App',
                  'Should see the correct title'

    assert_select 'input#user_name', true, 'Should see the name field'
    assert_select 'input#user_email', true, 'Should see the email field'
    assert_select 'input#user_password', true, 'Should see the password field'
    assert_select 'input#user_password_confirmation', true,
                  'Should see the password confirmation field'
  end

  test 'should 401-render login on edit when not logged in' do
    get :edit, id: @kylo

    assert_401_not_logged_in
  end

  test 'should 401-render login on update when not logged in' do
    patch :update, id: @kylo, user: { name: @kylo.name, email: @kylo.email }

    assert_401_not_logged_in
  end

  test 'should 401-render home on edit when logged in as wrong user' do
    log_in_as(@peaches)
    get :edit, id: @kylo

    # TODO: assert_permission_denied
    assert_flash type: :danger, expected: false
    assert_redirected_to root_url, 'Should be redirected to home page'
  end

  test 'should 401-render home on update when logged in as wrong user' do
    log_in_as(@peaches)
    patch :update, id: @kylo, user: { name: @kylo.name, email: @kylo.email }

    # TODO: assert_permission_denied
    assert_flash type: :danger, expected: false
    assert_redirected_to root_url, 'Should be redirected to home page'
  end

  test 'should 401-render login on index when not logged in' do
    get :index

    assert_401_not_logged_in
  end

  test 'should 401-render login on destroy when not logged in' do
    assert_no_difference 'User.count', 'Should not change User count' do
      delete :destroy, id: @batman
    end

    assert_401_not_logged_in
    assert_not session[:forwarding_url],
               'Session should not contain a forwarding url'
  end

  test 'destroy should redirect to index when not admin' do
    log_in_as @kylo
    assert_no_difference 'User.count', 'Should not change User count' do
      delete :destroy, id: @batman
    end

    # TODO: assert_permission_denied 'users/index'
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

  test 'should get show, unauthenticated' do
    get :show, id: @kylo.id
    assert_response :success, 'should return 200 OK'
    assert_select 'title', 'Kylo Ren | Ruby on Rails Tutorial Sample App'

    assert_rendered_user_info @kylo
    assert_rendered_follower_stats @kylo

    assert_select '#follow_form', false,
                  'Should not see the follow form when unauthenticated'
    assert_select '.microposts li', 4, 'Should see 4 microposts'
  end

  test 'should get show, logged in' do
    log_in_as @kylo
    get :show, id: @peaches.id
    assert_response :success, 'should return 200 OK'
    assert_select 'title',
                  'Peaches the Friendly Orc | Ruby on Rails Tutorial Sample App'

    assert_rendered_user_info @peaches
    assert_rendered_follower_stats @peaches

    assert_select '#follow_form input[value=?]', 'Follow', true,
                  'Should see the follow button when logged in'
    assert_select '.microposts li', 30, 'Should see 30 microposts'

    @kylo.follow @peaches
    get :show, id: @peaches.id

    assert_select '#follow_form input[value=?]', 'Unfollow', true,
                  'Should see the unfollow button when logged in and following'
  end

  test 'should get show, self' do
    log_in_as @kylo

    get :show, id: @kylo.id
    assert_response :success, 'should return 200 OK'
    assert_select 'title', 'Kylo Ren | Ruby on Rails Tutorial Sample App'

    assert_rendered_user_info @kylo
    assert_rendered_follower_stats @kylo
    assert_select '#follow_form', false,
                  'Should not see the follow form when viewing own profile'

    assert_rendered_micropost_form
    assert_select '.microposts li', 4, 'Should see 4 microposts'
  end

  test 'get to followers when unauthenticated should redirect to login' do
    get :following, id: @kylo
    assert_401_not_logged_in
  end

  test 'get to following when unauthenticated should redirect to login' do
    get :followers, id: @kylo
    assert_401_not_logged_in
  end
end
