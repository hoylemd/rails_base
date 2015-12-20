require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @batman = User.new(name: "Batman", email: "batman@wayneenterprises.com")
  end

  test "should be valid" do
    assert @batman.valid?
  end

  test "should have name" do
    @batman.name = ""
    assert_not @batman.valid?, "empty string should be invalid"
    @batman.name = "      "
    assert_not @batman.valid?, "whitespace only should be invalid"
  end

  test "name should not be too long" do
    @batman.name = 'a' * 51
    assert_not @batman.valid?, "#{@batman.name.length} should be too long"
  end

  test "should have email" do
    @batman.email = ""
    assert_not @batman.valid?, "empty string should be invalid"
    @batman.email = "      "
    assert_not @batman.valid?, "whitespace only should be invalid"
  end

  test "email should not be too long" do
    @batman.email = 'a' * 244 + '@example.com'
    assert_not @batman.valid?, "#{@batman.email.length} should be too long"
  end

  test "valid emails should be accepted" do
    emails = ["hello@example.com", "hello+tagged@example.com",
              "hi.myname@example.com", "lOo0ks_w13rd@example.com", "n@jp"]

    emails.each do |email|
      @batman.email = email
      assert @batman.valid?, "#{email} should be valid"
    end
  end
end
