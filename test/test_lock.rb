require 'test_helper'

class TestLockManagerLock < MiniTest::Test
  def setup
    @rlm = LockManager.new(type: 'redis', server: 'localhost')
    @rlm.unlock 'pe-aix-72-builder', 'stahnma' # clear out any previously set locks
  end

  def test_lock_method
    assert_equal true, @rlm.lock('pe-aix-72-builder', 'stahnma')
  end

  def test_check_lock
    @rlm.lock('pe-aix-72-builder', 'stahnma')
    assert_equal true, @rlm.locked?('pe-aix-72-builder')
  end

  def test_lock_a_locked_item
    @rlm.lock('pe-aix-72-builder', 'stahnma')
    assert_equal false, @rlm.lock('pe-aix-72-builder', 'stahnma')
  end
end
