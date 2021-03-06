require 'test_helper'

class AclHelperTest < ActionView::TestCase
  include AclHelper

  def setup
    @kylo = users(:kylo)
    @batman = users(:batman)
    @peaches = users(:peaches)
  end

  test 'current_user? fails for no user' do
    assert_not current_user? @kylo
  end

  test 'current_user? fails for wrong user' do
    log_in_as @batman
    assert_not current_user? @kylo
  end

  test 'current_user? fails for wrong user, even if they are admin' do
    log_in_as @peaches
    assert_not current_user? @kylo
  end

  test 'current_user? passes for the current user' do
    log_in_as @kylo
    assert current_user?(@kylo), 'Correct user should be true'
  end

  test 'correct_user? passes for correct current user' do
    log_in_as @kylo

    assert correct_user? @kylo
  end

  test 'correct_user? passes for admin current user' do
    log_in_as @peaches

    assert correct_user? @kylo
  end

  test 'correct_user? fails for no user' do
    assert_not correct_user? @kylo
  end

  test 'correct_user? fails for wrong user' do
    log_in_as @batman
    assert_not correct_user? @kylo
  end

  test 'correct_user? uses passed test' do
    test = proc { |user| user == @kylo }

    assert correct_user? @kylo, test: test
    assert_not correct_user? @peaches, test: test
  end
end
