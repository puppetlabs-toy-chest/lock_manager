require 'test_helper'

class TestLockManagerPoll < MiniTest::Test
  def setup
    @rlm = LockManager.new('localhost', 'pe-aix-72-builder', 'stahnma')
    @rlm.unlock
  end

  def test_polling_lock
    assert_equal true, @rlm.polling_lock
  end

  def test_polling_lock_when_locked_already
    skip "I don't know how to test the case where it is locked, since it just blocks"
  end
end
