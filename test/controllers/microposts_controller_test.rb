require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  def setup
    @parsecs = microposts(:parsecs)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: { content: 'Lorem ipsum' }
    end
    assert_template 'sessions/new', 'Should be redirected to login page'
  end

  test 'should accept create when logged in' do
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @parsecs
    end
    assert_template 'sessions/new', 'Should be redirected to login page'
  end

  test 'should redirect destroy when not owning tweet' do
    log_in_as users(:batman)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @parsecs
    end
    assert_flash type: :danger,
                 expected: 'Sorry, you don\'t have permission to do that'
    assert_redirected_to root_path, 'Should be redirected to home page'
  end

  test 'should accept destroy when correct user' do
  end

  test 'should accept destroy when admin' do
  end
end
