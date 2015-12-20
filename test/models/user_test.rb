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
    assert_not @batman.valid?
    @batman.name = "      "
    assert_not @batman.valid?
  end

  test "name should not be too long" do
    @batman.name = 'a' * 51
    assert_not @batman.valid?
  end

  test "should have email" do
    @batman.email = ""
    assert_not @batman.valid?
    @batman.email = "      "
    assert_not @batman.valid?
  end

  test "email should not be too long" do
    @batman.email = 'a' * 244 + '@example.com'
    assert_not @batman.valid?
  end
end
