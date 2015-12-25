require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'gravatar_for generates corect html' do
    user = users(:peaches)

    assert_equal('<img alt="Peaches the Friendly Orc" class="gravatar" ' \
                 'src="https://secure.gravatar.com/avatar/' \
                 '0298badedee3c87e93655f53ebab9fe0?size=80" />',
                 gravatar_for(user))
  end

  test 'gravatar_for accepts size parameter' do
    user = users(:peaches)

    assert_equal('<img alt="Peaches the Friendly Orc" class="gravatar" ' \
                 'src="https://secure.gravatar.com/avatar/' \
                 '0298badedee3c87e93655f53ebab9fe0?size=234" />',
                 gravatar_for(user, size: 234))
  end
end
