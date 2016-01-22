require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  def setup
    @kylo = users(:kylo)
  end

  test 'get to home should respond with 200 OK and render home template' do
    get :home

    assert_template 'static_pages/home', 'Should be on home page'
  end

  # TODO: move this to a cuke layout test
  test 'get to home while logged in' do
    log_in_as @kylo
    get :home

    assert_template 'static_pages/home', 'Should be on home page'
    assert_select 'a[href=?]', root_path, { count: 2 },
                  'Should see 2 home links'
    assert_select 'a[href=?]', help_path, true, 'Should see a help link'
    assert_select 'a[href=?]', about_path, true, 'Should see an about link'
    assert_select 'a[href=?]', users_path, true, 'Should see a users link'
    assert_select 'a[href=?]', user_path(@kylo), true,
                  'Should see a profile link'
    assert_select 'a[href=?]', contact_path, true, 'Should see a contact link'
    assert_select 'a[href=?]', login_path, false, 'Should not see a login link'
    assert_select 'a[href=?]', logout_path, true, 'Should see a logout link'
    assert_select 'a[href=?]', signup_path, false, 'Should see a signup link'

    assert_template 'shared/_user_info', 'Should see user info'

    assert_rendered_user_info @kylo
    assert_rendered_micropost_form
    assert_rendered_follower_stats @kylo
    assert_rendered_feed
  end

  test 'should get help' do
    get :help
    assert_response :success, 'Should receive a 200 OK on GET to help'
    assert_select 'title', 'Help | Rails Base'
  end

  test 'should get about' do
    get :about
    assert_response :success, 'Should receive a 200 OK on GET to help'
    assert_select 'title', 'About | Rails Base'
  end

  test 'should get contact' do
    get :contact
    assert_response :success, 'Should receive a 200 OK on GET to contact'
    assert_select 'title', 'Contact | Rails Base'
  end
end
