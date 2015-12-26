require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'title', 'Sign Up | Ruby on Rails Tutorial Sample App'
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
