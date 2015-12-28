require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'layout links, unauthenticated' do
    get root_path

    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', signup_path

    get signup_path
    assert_select 'title', full_title('Sign Up')
  end

  test 'layout links, authenticated' do
    log_in_as @kylo
    get root_path

    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', users_path, count: 1
    assert_select 'a[href=?]', user_path(@kylo), count: 1
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path, count: 1
    assert_select 'a[href=?]', signup_path, count: 1
  end
end
