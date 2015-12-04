require 'test_helper'

class TestLockManagerInspect < MiniTest::Test
  def setup
    @rlm = LockManager.new('localhost', 'pe-aix-72-builder', 'stahnma')
  end

  def test_inspect_works_with_lock
    @rlm.lock
    assert_instance_of(Hash, JSON.parse(@rlm.inspect))
  end

  def test_inspect_returns_nothing_with_no_lock
    @rlm.unlock
    assert_nil(@rlm.inspect)
  end
end
