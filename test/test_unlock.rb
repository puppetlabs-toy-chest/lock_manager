require 'test_helper'

class TestLockManagerUnlock < MiniTest::Test
  def setup
    @rlm = LockManager.new('localhost', 'pe-aix-72-builder', 'stahnma')
    @rlm.lock
  end

  def test_unlock_method
    assert_equal(true, @rlm.unlock)
  end

  def test_check_locked?
    @rlm.unlock
    assert_equal(false, @rlm.locked?)
    @rlm.lock
    assert_equal(true, @rlm.locked?)
    @rlm.unlock
  end

  def test_unlock_an_unlocked_item
    @rlm.unlock
    assert_equal(false, @rlm.unlock)
  end

  def test_dont_unlock_a_lock_not_with_owner_mismatch
    @rlm.user = 'fooman'
    assert_equal(false, @rlm.unlock)
    @rlm.user = 'stahnma'
    assert_equal(true, @rlm.unlock)
  end
end
