require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    @crichton = users(:crichton)
  end

  test 'index has pagination and at least 30 users, with links to profiles' do
    log_in_as @kylo
    get users_path
    assert_select 'div.pagination', 2, 'Should see 2 pagination controls'
    assert_select '.users li', 30, 'Should see 30 users'
    User.where(verified: true).paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test 'get to users index when unverified redirects to root' do
    log_in_as @crichton

    get_via_redirect users_path

    assert_template 'static_pages/home', 'Should be on home page'
    assert_flash(type: 'danger',
                 expected: 'Sorry, you don\'t have permission to do that')
  end

  test 'index does not display unverified users to non-admin users' do
    # verify that kylo doesn't see crichton

    # verify that peaches does see crichton
  end
end
