require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'home page layout, unauthenticated' do
    get root_path

    assert_template 'static_pages/home', 'Should be on home page'
    assert_select 'a[href=?]', root_path, { count: 2 },
                  'Should see 2 home links'
    assert_select 'a[href=?]', help_path, true, 'Should see a help link'
    assert_select 'a[href=?]', about_path, true, 'Should see an about link'
    assert_select 'a[href=?]', users_path, false, 'Should not see a users link'
    assert_select 'a[href=?]', contact_path, true, 'Should see a contact link'
    assert_select 'a[href=?]', login_path, true, 'Should see a login link'
    assert_select 'a[href=?]', logout_path, false, "Shouldn't see a logout link"
    assert_select 'a[href=?]', signup_path, true, 'Should see a signup link'
  end

  test 'signup page layout' do
    get signup_path
    assert_select 'title', full_title('Sign Up'),
                  'Signup title should be correct'
  end

  test 'home page layout, authenticated' do
    log_in_as @kylo
    get root_path

    assert_template 'static_pages/home', 'Should be on home page'
    assert_select 'a[href=?]', root_path, { count: 2 },
                  'Should see 2 home links'
    assert_select 'a[href=?]', help_path, true, 'Should see a help link'
    assert_select 'a[href=?]', about_path, true, 'Should see an about link'
    assert_select 'a[href=?]', users_path, true, 'Should see a users link'
    assert_select 'a[href=?]', user_path(@kylo), true,
                  'Should see a profile link'
    assert_select 'a[href=?]', contact_path, true, 'Should see a contact link'
    assert_select 'a[href=?]', login_path, false, 'Should not see a login link'
    assert_select 'a[href=?]', logout_path, true, 'Should see a logout link'
    assert_select 'a[href=?]', signup_path, false, 'Should see a signup link'

    assert_template 'shared/_user_info', 'Should see user info'
    assert_rendered_user_info @kylo

    assert_template 'shared/_micropost_form', 'Should see a micropost form'

    assert_template 'shared/_feed', 'Should see the microposts feed'
  end
end
