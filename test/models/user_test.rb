require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @batman = users(:batman)
  end

  test 'should be valid' do
    assert @batman.valid?
  end

  test 'should have name' do
    @batman.name = ''
    assert_not @batman.valid?, 'empty string should be invalid'
    @batman.name = '      '
    assert_not @batman.valid?, 'whitespace only should be invalid'
  end

  test 'name should not be too long' do
    @batman.name = 'a' * 51
    assert_not @batman.valid?, "#{@batman.name.length} should be too long"
  end

  test 'should have email' do
    @batman.email = ''
    assert_not @batman.valid?, 'empty string should be invalid'
    @batman.email = '      '
    assert_not @batman.valid?, 'whitespace only should be invalid'
  end

  test 'email should not be too long' do
    @batman.email = 'a' * 244 + '@example.com'
    assert_not @batman.valid?, "#{@batman.email.length} should be too long"
  end

  test 'valid emails should be accepted' do
    emails = ['hello@example.com', 'hello+tagged@example.com',
              'hi.myname@example.com', 'lOo0ks_w13rd@example.com', 'n@jp']

    emails.each do |email|
      @batman.email = email
      assert @batman.valid?, "#{email} should be valid"
    end
  end

  test 'invalid emails should be rejected' do
    emails = ['user@example,com', 'user_at_foo.org', 'user.name@example.',
              'foo@bar_baz.com', 'foo@bar+baz.com', 'luke@sky..walk.er']

    emails.each do |email|
      @batman.email = email
      assert_not @batman.valid?, "#{email} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @batman.dup
    @batman.save
    assert_not duplicate_user.valid?,
               'duplicate email address should be rejected'
    duplicate_user.email = @batman.email.upcase
    assert_not duplicate_user.valid?, 'duplication should be case-insensitive'
  end

  test 'email addresses should be normalized as lower case' do
    @batman.email = 'BATman@wayneenterprises.com'
    @batman.save
    assert @batman.email = 'batman@wayneenterprises.com'
  end

  test 'passwords should be absent or non blank and equal' do
    assert @batman.valid?, 'absent passwords should be valid'

    @batman.password = nil
    @batman.password_confirmation = nil
    assert_not @batman.valid?, 'nil passwords should be invalid'

    @batman.password = ''
    @batman.password_confirmation = ''
    assert_not @batman.valid?, 'empty passwords should be invalid'

    @batman.password = '          '
    @batman.password_confirmation = '          '
    assert_not @batman.valid?, 'whitespace password should be invalid'

    @batman.password = 'password'
    @batman.password_confirmation = 'hunter22'
    assert_not @batman.valid?, 'mismatched passwords should be invalid'

    @batman.password = 'hunter22'
    @batman.password_confirmation = 'hunter22'
    assert @batman.valid?, 'matching passwords should be valid'
  end

  test 'passwords should be at least 8 characters' do
    @batman.password = '1234'
    @batman.password_confirmation = '1234'
    assert_not @batman.valid?, 'too-short passwords should be invalid'
  end

  test 'digest should encrypt the given string' do
    regex = /^\$2a\$04\$.{53}$/
    string = "that's not how the force works!"
    hash = User.digest(string)
    assert regex.match(hash), 'output should be a min-cost bcrypt hash'
  end

  test 'new_token' do
    regex = /^[a-zA-Z0-9\-_]{22}$/
    token = User.new_token
    assert regex.match(token),
           "token (#{token}) should be 22-length base64 string"
  end

  test 'authenticated? should return false for no token' do
    assert_not @batman.authenticated?(''), 'should return false for empty token'
    assert_not @batman.authenticated?(nil), 'should return false for nil token'
  end

  test 'authenticated? should return true for correct token' do
    token = 'myparentsaredeaaaaad'
    @batman[:remember_digest] = User.digest(token)
    assert @batman.authenticated?(token), 'should return true cor correct token'
  end

  test 'authenticated? should return false for incorrect token' do
    @batman[:remember_digest] = User.digest('myparentsaredeaaaaad')
    assert_not @batman.authenticated?('thecapedcrusader'),
               'should return false for incorrect token'
  end

  test 'remember generates and stores a token and digest' do
    @batman.remember
    assert_not @batman.remember_token.nil?, 'should have a remember_token'
    assert_not @batman.remember_digest.nil?, 'should have a remember_digest'
  end

  test 'forget removes remember token' do
    @batman.remember_digest = 'nananananananananana MEEEEEEE'

    @batman.forget
    assert @batman.remember_digest.nil?, 'remember_digest should be nil'
  end
end
