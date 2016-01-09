require 'test_helper'

class MicropostManipulationTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
    @parsecs = microposts(:parsecs)
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
    assert_401_not_logged_in

    log_in_as @kylo
    get root_path
    assert_rendered_micropost_form

    msg = "Micropost count shouldn't increase on empty micropost"
    assert_no_difference 'Micropost.count', msg do
      post_via_redirect microposts_path, micropost: { content: '' }
    end
    assert_response :unprocessable_entity,
                    'Should get a 422 Unprocessable error'
    assert_template 'static_pages/home',
                    'Should be redirected to home on error'
    assert_error_messages(explanations: ['Content can\'t be blank'])

    msg = "Micropost count shouldn't increase on too-long micropost"
    assert_no_difference 'Micropost.count', msg do
      post_via_redirect microposts_path, micropost: { content: 'a' * 141 }
    end
    assert_response :unprocessable_entity,
                    'Should get a 422 Unprocessable error'
    assert_error_messages(
      explanations: ['Content is too long (maximum is 140 characters)'])

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
    log_in_as @kylo

    msg = 'Should decrease micropost count'
    assert_difference 'Micropost.count', -1, msg do
      delete_via_redirect micropost_path @parsecs
    end

    assert_template 'static_pages/home', 'Should be redirected to home page'
    assert_flashes success: 'Micropost deleted'
  end
end
