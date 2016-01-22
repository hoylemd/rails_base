require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal 'Rails Base', full_title
    assert_equal 'Help | Rails Base', full_title('Help')
  end
end
