require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    @peaches = users(:peaches)
    @batman = users(:batman)
  end

  test 'User profile page should show at most 30 microposts' do
    get user_path @peaches
    assert_response :success, 'Should respond to GET with 200 OK'
    assert_select '.microposts li', { count: 30 },
                  'Should see 30 microposts for user with > 30 microposts'

    get user_path @kylo
    assert_select '.microposts li', { count: 4 },
                  'Should see all microposts for user with < 30 microposts'

    get user_path @batman

    assert_select '.microposts', "#{@batman.name} hasn't posted anything yet!",
                  'Should see \'no posts\' message for user with no microposts'
  end
end
