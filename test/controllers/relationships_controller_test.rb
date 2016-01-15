require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
  def setup
    @batman = users(:batman)
    @kylo = users(:kylo)
  end

  test 'create should require authentication' do
    assert_no_difference 'Relationship.count' do
      post :create
    end

    assert_401_not_logged_in
  end

  test 'destroy should require authentication' do
    assert_no_difference 'Relationship.count' do
      post :create
    end

    assert_401_not_logged_in
  end

  test 'post to create creates relationship & redirects' do
    log_in_as @kylo

    assert_difference 'Relationship.count', 1 do
      post :create, followed_id: @batman.id
    end

    assert_response :redirect, 'Should get a 301 response'
  end

  test 'delete to destroy destroys relationship & redirects' do
    # I, Ross, take thee, Rachel...
    log_in_as @batman

    ship = Relationship.find_by(followed_id: @kylo.id)

    assert_difference 'Relationship.count', -1 do
      delete :destroy, id: ship.id
    end

    assert_response :redirect, 'Should get a 301 response'
  end
end
