require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    @kylo = users(:kylo)
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_select 'input#session_email', 1, 'one email input should be present'
    assert_select 'input#session_password', 1,
                  'one password input should be present'
    assert_select 'input#session_remember_me', 1,
                  'one remember input should be present'
  end

  test 'post to create, valid' do
    post :create, session: { email: @kylo.email, password: 'password' }
    assert_redirected_to @kylo
  end
  # TODO: 'post to create, invalid'
  # TODO: 'delete to destroy'
end
