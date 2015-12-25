require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'should get new' do
    get :new
    assert_response :success
    # TODO: assert some things on the page
  end

  # TODO: 'post to create, valid'
  # TODO: 'post to create, invalid'
  # TODO: 'delete to destroy'
end
