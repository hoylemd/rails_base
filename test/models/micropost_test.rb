require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @kylo = users(:kylo)
    # This code is not idiomatically correct.
    @micropost = Micropost.new(
      user_id: @kylo.id,
      content: 'i think dad\'s walking carpet resents me for some reason')
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
end
