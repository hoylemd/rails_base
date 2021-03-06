require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @kylo = users(:kylo)
    @peaches = users(:peaches)
    @quiet = users(:quiet)
  end

  test 'profile display' do
    get user_path(@peaches)
    assert_template 'users/show', 'Should be on the user profile page'
    assert_select 'title', full_title(@peaches.name),
                  'Title should display user\'s name'

    assert_rendered_user_info @peaches

    assert_select 'div.pagination', true, 'Pagination controls should appear'
    @peaches.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body,
                   'Micropost content should be correct'
    end
  end

  test 'own profile page' do
    log_in_as @peaches
    get user_path(@peaches)

    assert_template 'users/show', 'Should be on the user profile page'
    assert_select 'title', full_title(@peaches.name),
                  'Title should display user\'s name'

    assert_rendered_user_info @peaches

    assert_rendered_micropost_form

    assert_select 'div.pagination', true, 'Pagination controls should appear'
    @peaches.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body,
                   'Micropost content should be correct'
    end
  end

  test 'User profile page should show at most 30 microposts' do
    get user_path @peaches
    assert_response :success, 'Should respond to GET with 200 OK'
    assert_select '.microposts li', { count: 30 },
                  'Should see 30 microposts for user with > 30 microposts'

    get user_path @kylo
    assert_select '.microposts li', { count: 4 },
                  'Should see all microposts for user with < 30 microposts'

    get user_path @quiet

    assert_select '.microposts', "#{@quiet.name} hasn't posted anything yet!",
                  'Should see \'no posts\' message for user with no microposts'
  end
end
