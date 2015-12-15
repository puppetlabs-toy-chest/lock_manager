require 'test_helper'

class TestLockManagerUnlock < MiniTest::Test
  def setup
    @rlm = LockManager.new(type: 'redis', server: 'localhost')
    @rlm.unlock 'pe-aix-72-builder', 'stahnma' # clear out any previously set locks
    @rlm.lock 'pe-aix-72-builder', 'stahnma' # clear out any previously set locks
  end

  def test_unlock_method
    assert @rlm.unlock('pe-aix-72-builder', 'stahnma')
  end

  def test_check_locked?
    @rlm.unlock 'pe-aix-72-builder', 'stahnma'
    assert_equal(false, @rlm.locked?('pe-aix-72-builder'))
    @rlm.lock 'pe-aix-72-builder', 'stahnma'
    assert_equal(true, @rlm.locked?('pe-aix-72-builder'))
    @rlm.unlock 'pe-aix-72-builder', 'stahnma'
  end

  def test_unlock_an_unlocked_item
    @rlm.unlock 'pe-aix-72-builder', 'stahnma'
    refute @rlm.unlock 'pe-aix-72-builder', 'stahnma'
  end

  def test_dont_unlock_a_lock_not_with_owner_mismatch
    refute @rlm.unlock 'pe-aix-72-builder', 'fooman'
    assert @rlm.unlock 'pe-aix-72-builder', 'stahnma'
  end
end
