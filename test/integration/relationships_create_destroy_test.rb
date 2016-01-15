require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @batman = users(:batman)
    @kylo = users(:kylo)
  end

  test 'clicking follow/unfollow updates relationships' do
    log_in_as @kylo
    get user_path(@batman)

    assert_select '#follow_form input[value=?]', 'Follow', true,
                  'Should see the follow button'

    assert_difference 'Relationship.count', 1 do
      xhr :post, relationships_path, followed_id: @batman.id
    end
  end

  test 'clicking unfollow destroys relationship' do
    log_in_as @batman
    get user_path @kylo

    assert_select '#follow_form input[value=?]', 'Unfollow', true,
                  'Should see the unfollow button'

    ship = Relationship.find_by(followed_id: @kylo.id)

    assert_difference 'Relationship.count', -1 do
      xhr :delete, relationship_path(ship)
    end
  end
  # TODO: When this gets turned into capybara test, it should ensure that the
  # button changes
end
