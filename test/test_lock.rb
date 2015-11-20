require 'minitest/autorun'
require 'lock_manager'

class TestLockManagerLock < MiniTest::Test
  def setup
    @rlm = LockManager.new('localhost', 'pe-aix-72-builder', 'stahnma')
    @rlm.unlock
  end

  def test_lock_method
    assert_equal true, @rlm.lock
  end

  def test_check_lock
    @rlm.lock
    assert_equal true, @rlm.locked?
  end

  def test_lock_a_locked_item
    @rlm.lock
    assert_equal false, @rlm.lock
  end
end
