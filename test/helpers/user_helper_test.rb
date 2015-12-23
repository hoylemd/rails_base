require 'test_helper'

class UsersHelperTest < ActionView::TestCase
  test 'gravatar_for generates corect html' do
    user = User.new(email: 'peachesthefriendlyorc@gmail.com',
                    name: 'Peaches the Friendly Orc')

    assert_equal(gravatar_for(user),
                 '<img alt="Peaches the Friendly Orc" class="gravatar" ' \
                 'src="https://secure.gravatar.com/avatar/' \
                 '0298badedee3c87e93655f53ebab9fe0?size=80" />')
  end
end
