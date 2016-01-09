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

  # TODO: implement this
  test 'post to create should create session on correct credentials' do
    # no credentials
    # wrong un/password
    # correct credentials
  end

  test 'should redirect to profile on post valid credentials to create' do
    post :create, session: { email: @kylo.email, password: 'password' }
    assert_redirected_to @kylo, 'should be redirected '
  end

  test 'should error on post invalid credentials to create' do
    post :create, session: { email: @kylo.email, password: 'letmeinplease' }
    assert_response :unauthorized, 'should report a 401 UNAUTHORIZED error'
  end

  test 'delete to destroy clears session, if logged in' do
    delete :destroy
    assert_redirected_to login_path,
                         'Should redirect to login page when not logged in'

    log_in_as @kylo

    delete :destroy
    assert_redirected_to login_url,
                         'Should redirect to login page when logged in'
    assert session[:user_id].nil?, 'User id should be removed from session'
  end
end
