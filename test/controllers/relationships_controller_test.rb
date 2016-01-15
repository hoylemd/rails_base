require 'test_helper'

class RelationshipsControllerTest < ActionController::TestCase
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
end
