require 'test_helper'

class StaticPagesControllerTest < ActionController::TestCase
  # TODO: fill these out with layout assertions
  test 'should get home' do
    get :home
    assert_response :success, 'Should receive a 200 OK on GET to home'
    assert_select 'title', 'Ruby on Rails Tutorial Sample App'
  end

  test 'should get help' do
    get :help
    assert_response :success, 'Should receive a 200 OK on GET to help'
    assert_select 'title', 'Help | Ruby on Rails Tutorial Sample App'
  end

  test 'should get about' do
    get :about
    assert_response :success, 'Should receive a 200 OK on GET to help'
    assert_select 'title', 'About | Ruby on Rails Tutorial Sample App'
  end

  test 'should get contact' do
    get :contact
    assert_response :success, 'Should receive a 200 OK on GET to contact'
    assert_select 'title', 'Contact | Ruby on Rails Tutorial Sample App'
  end
end
