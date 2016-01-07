require 'test_helper'

class MicropostManipulationTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'create new micropost' do
    poetry =
      "dear diary\ni think my voice is changing\n" \
      "but it could be that i'm wearing a helmet with a voice changer now"

    assert_no_difference(
      'Micropost.count', "Micropost count shouldn't increase when not logged in"
    ) do
      post_via_redirect microposts_path, micropost: { content: poetry }
    end
    assert_response :unauthorized, 'Should get a 401 unauthorized error'
    assert_template 'sessions/new',
                    'Should be redirected to login when not logged in'
    assert_error_messages(flash: 'Please log in first')

    log_in_as @kylo
    get root_path
    # TODO: assert the form is present

    msg = "Micropost count shouldn't increase on bad micropost"
    assert_no_difference 'Micropost.count', msg do
      post_via_redirect microposts_path, micropost: { content: 'a' * 141 }
    end
    assert_response :unprocessable_entity,
                    'Should get a 422 Unprocessable error'
    assert_template 'static_pages/home',
                    'Should be redirected to home on error'
    assert_error_messages(
      flash: 'Microposts must be 140 characters or less')

    msg = 'Micropost count should increase'
    assert_difference 'Micropost.count', 1, msg do
      post_via_redirect microposts_path, micropost: { content: poetry }
    end

    assert_template 'users/show', 'Should be redirected to profile page'
    assert_flash success: 'Micropost created!'

    assert_select '.microposts li .content', poetry,
                  'New post should appear on user profile page'
  end

  test 'delete to micropost deletes it' do
  end
end
