require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @kylo = users(:kylo)
  end

  test 'log_in stores the passed user_id in the session' do
    assert session[:user_id].nil?, 'session should not have a user id'

    log_in(@kylo)
    assert session[:user_id], 'session should have a user id'
  end

  # TODO: 'log_in stored remember digest if permanent flag'

  test 'current_user returns the current user or nil' do
    assert @current_user.nil?, '@current_user should be nil'

    log_in_as(@kylo)
    assert current_user == @kylo, 'current_user should return Kylo Ren'
    assert @current_user == @kylo, '@current_user should be Kylo Ren'
  end

  test 'current_user returns right user when session is nil' do
    remember(@kylo)
    assert_equal @kylo, current_user
    assert logged_in?
  end

  test 'current_user returns nil when remember digest is wrong' do
    @kylo.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test 'logged_in? tells if someone is logged in' do
    assert_not logged_in?, 'should not be logged in'

    log_in_as(@kylo)
    assert logged_in?, 'should be logged in'
  end

  test 'log_out clears user id from session' do
    log_in_as(@kylo)

    log_out
    assert session[:user_id].nil?, 'session should not contain user id'
  end

  # TODO: 'remember generates and stores remember credentials'
  # TODO: 'forget removes remember credentials'
end
