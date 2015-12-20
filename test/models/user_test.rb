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
end
