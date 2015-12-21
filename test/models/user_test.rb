require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @batman = User.new(name: 'Batman', email: 'batman@wayneenterprises.com',
                       password: 'myparentsaredead',
                       password_confirmation: 'myparentsaredead')
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
              'foo@bar_baz.com', 'foo@bar+baz.com']

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

  test 'password should be present and non blank' do
    @batman.password = nil
    assert_not @batman.valid?, 'nil password should be invalid'
    @batman.password = ''
    assert_not @batman.valid?, 'empty password should be invalid'
    @batman.password = '          '
    assert_not @batman.valid?, 'whitespace password should be invalid'
  end

  test 'password should be at least 8 characters' do
    @batman.password = '1234'
    assert_not @batman.valid?, 'too-short password should be invalid'
  end
end
