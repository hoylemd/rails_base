require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  test 'log_in stores the passed user_id in the session' do
    assert session[:user_id].nil?, 'session should not have a user id'
    log_in(User.create(name: 'Kylo Ren', email: 'vaderFan667@hotmail.com',
                       password: 'starkiller',
                       password_confirmation: 'starkiller'))
    assert session[:user_id], 'session should have a user id'
  end

  test 'current_user returns the current user or nil' do
  end
end
