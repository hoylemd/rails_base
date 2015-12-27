require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'index has pagination and at least 30 users, with links to profiles' do
    log_in_as @kylo
    get users_path
    assert_select 'div.pagination', 2, 'Should see 2 pagination controls'
    assert_select '.users li', 30, 'Should see 30 users'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end
