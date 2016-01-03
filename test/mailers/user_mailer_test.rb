require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @kylo = users(:kylo)
    @kylo.verification_token = User.new_token
  end

  test 'email_verification' do
    mail = UserMailer.email_verification @kylo
    assert_equal 'Email verification', mail.subject
    assert_equal [@kylo.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match "Hi #{@kylo.name},", mail.body.encoded
    assert_match @kylo.verification_token, mail.body.encoded
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
