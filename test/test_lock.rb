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
    @rlm.lock('pe-aix-72-builder', 'stahnma', 'because reasons')
    assert_equal true, @rlm.locked?('pe-aix-72-builder')
  end

  def test_lock_a_locked_item
    @rlm.lock('pe-aix-72-builder', 'stahnma')
    assert_equal false, @rlm.lock('pe-aix-72-builder', 'stahnma')
  end

  def test_lock_with_ip4
    assert_raises(ArgumentError) do
      @rlm.lock('192.168.1.1', 'stahnma')
    end
  end

  def test_lock_with_ip6
    assert_raises(ArgumentError) do
      @rlm.lock('fe80::12c3:7bff:fe90:dc60', 'stahnma')
    end
  end
end
