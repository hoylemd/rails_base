require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @kylo = User.create(name: 'Kylo Ren', email: 'vaderFan667@hotmail.com',
                        password: 'starkiller',
                        password_confirmation: 'starkiller')
  end

  test 'log_in stores the passed user_id in the session' do
    assert session[:user_id].nil?, 'session should not have a user id'

    log_in(@kylo)
    assert session[:user_id], 'session should have a user id'
  end

  test 'current_user returns the current user or nil' do
    assert @current_user.nil?, '@current_user should be nil'

    session[:user_id] = @kylo.id
    assert current_user == @kylo, 'current_user should return Kylo Ren'
    assert @current_user == @kylo, '@current_user should be Kylo Ren'
  end

  test 'logged_in? tells if someone is logged in' do
    assert_not logged_in?, 'should not be logged in'

    session[:user_id] = @kylo.id
    assert logged_in?, 'should be logged in'
  end
end
