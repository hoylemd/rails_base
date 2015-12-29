require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @kylo = users(:kylo)
    @kylo.activation_token = User.new_token
  end

  test 'account_activation' do
    mail = UserMailer.account_activation @kylo
    assert_equal 'Account activation', mail.subject
    assert_equal [@kylo.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match "Hi #{@kylo.name},", mail.body.encoded
    assert_match @kylo.activation_token, mail.body.encoded
    assert_match CGI.escape(@kylo.email), mail.body.encoded
  end

  test 'password_reset' do
    mail = UserMailer.password_reset
    assert_equal 'Password reset', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end
end
