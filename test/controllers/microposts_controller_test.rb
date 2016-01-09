require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @parsecs = microposts(:parsecs)
  end

  test 'should 401-render login on create when not logged in' do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: 'Lorem ipsum' }
    end

    assert_401_not_logged_in
  end

  test 'should accept create when logged in' do
  end

  test 'should 401-render login on destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @parsecs
    end

    assert_401_not_logged_in
  end

  test 'should 401-render home on destroy when wrong user' do
    log_in_as users(:batman)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @parsecs
    end

    assert_permission_denied
  end

  test 'should accept destroy when correct user' do
    log_in_as users(:kylo)

    delete :destroy, id: @parsecs

    assert_redirected_to root_path, 'Should be redirected to home page'
    assert_flashes success: 'Micropost deleted'
  end

  test 'should accept destroy when admin' do
    log_in_as users(:peaches)

    delete :destroy, id: @parsecs

    assert_redirected_to root_path, 'Should be redirected to home page'
    assert_flashes success: 'Micropost deleted'
  end
end
