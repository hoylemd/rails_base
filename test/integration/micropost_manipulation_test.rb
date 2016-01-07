require 'test_helper'

class MicropostManipulationTest < ActionDispatch::IntegrationTest
  def setup
    @kylo = users(:kylo)
  end

  test 'post to microposts creates new micropost for current user' do
  end

  test 'delete to micropost deletes it' do
  end
end
