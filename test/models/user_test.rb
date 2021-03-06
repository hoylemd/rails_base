require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @batman = users(:batman)
    @kylo = users(:kylo)
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
    assert_not @batman.authenticated?(:remember, ''),
               'should return false for empty token'
    assert_not @batman.authenticated?(:remember, nil),
               'should return false for nil token'
  end

  test 'authenticated? should return true for correct token' do
    token = 'myparentsaredeaaaaad'
    @batman[:remember_digest] = User.digest(token)
    assert @batman.authenticated?(:remember, token),
           'should return true cor correct token'
  end

  test 'authenticated? should return false for incorrect token' do
    @batman[:remember_digest] = User.digest('myparentsaredeaaaaad')
    assert_not @batman.authenticated?(:remember, 'thecapedcrusader'),
               'should return false for incorrect token'
  end

  test 'authenticated? should return false for no digest' do
    @batman[:remember_digest] = nil
    assert_not @batman.authenticated?(:remember, 'thecapedcrusader'),
               'should return false for no digest'
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

  test 'Users are not admins by default' do
    rey = User.create(name: 'Rey',
                      email: 'rey@jakku.net',
                      password: 'password',
                      password_confirmation: 'password')

    assert_not rey.admin, 'Should not be an admin'
  end

  test 'reset_token_expired? correctly checks for token expiration' do
    assert_not @batman.reset_token_expired?,
               'no digest should not count as expired'

    @batman.reset_sent_at = 1.hour.ago
    assert_not @batman.reset_token_expired?,
               '1 hour old token should not be expired'

    @batman.reset_sent_at = 3.hours.ago
    assert @batman.reset_token_expired?, '3 hour old token should be expired'
  end

  test 'associated microposts should be destroyed' do
    @batman.save
    assert_difference 'Micropost.count', -1 do
      @batman.destroy
    end
  end

  test 'microposrs should return user\'s microposts' do
    posts = @kylo.microposts

    assert_equal 4, posts.length, 'Should show all of a user\'s microposts'
    assert_equal microposts(:most_recent), posts[0],
                 'Posts should be in reverse-chronological order'
  end

  test 'should follow and unfollow a user' do
    assert_not @kylo.following?(@batman), 'no active relationship by default'
    assert_not @batman.followers.include?(@kylo),
               'no passive relationship by default'
    @kylo.follow(@batman)
    assert @kylo.following?(@batman), 'following? is true after follow'
    assert @batman.followers.include?(@kylo),
           'follower is in followed user\'s followers'
    @kylo.unfollow(@batman)
    assert_not @kylo.following?(@batman), 'following? is false after unfollow'
    assert_not @batman.followers.include?(@kylo),
               'follower is not in followed user\'s followers after unfollow'
    assert_raise NoMethodError, 'unfollow on not-followed user errors' do
      @kylo.unfollow(@batman)
    end
  end

  test 'feed should have the right posts' do
    ross = users(:ross)

    # Posts from followed user
    @kylo.microposts.each do |post_following|
      assert @batman.feed.include?(post_following),
             "Should see post '#{post_following.content}'"
    end
    # Posts from self
    @batman.microposts.each do |post_self|
      assert @batman.feed.include?(post_self),
             "Should see post '#{post_self.content}'"
    end
    # Posts from unfollowed user
    ross.microposts.each do |post_unfollowed|
      assert_not @batman.feed.include?(post_unfollowed),
                 "Should not see post '#{post_unfollowed.content}'"
    end

    assert_equal microposts(:most_recent), @kylo.microposts[0],
                 'Posts should be in reverse-chronological order'
  end
end
