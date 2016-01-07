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

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @parsecs
    end
    assert_template 'sessions/new', 'Should be redirected to login page'
  end
end
