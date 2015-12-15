require 'test_helper'

class TestLockManagerShow < MiniTest::Test
  def setup
    @rlm = LockManager.new(type: 'redis', server: 'localhost')
    @rlm.unlock 'pe-aix-72-builder', 'stahnma' # clear out any previously set locks
  end

  def test_show_works_with_lock
    assert @rlm.lock('pe-aix-72-builder', 'stahnma'), 'Expected to be able to lock'
    lock_data = @rlm.show('pe-aix-72-builder')
    assert_equal 'stahnma', lock_data['user'], 'Expected user to be properly set'
    assert_nil lock_data['reason'], 'Expected no reason to be set'
  end

  def test_show_works_with_lock_with_reason
    assert @rlm.lock('pe-aix-72-builder', 'stahnma', 'because'), 'Expected to be able to lock'
    lock_data = @rlm.show('pe-aix-72-builder')
    assert_equal 'stahnma', lock_data['user'], 'Expected user to be set'
    assert_equal 'because', lock_data['reason'], 'Expected reason to be set'
  end

  def test_show_returns_nothing_with_no_lock
    @rlm.unlock 'pe-aix-72-builder', 'stahnma'
    lock_data = @rlm.show('pe-aix-72-builder')
    assert_nil lock_data, 'Expected no lock to be set'
  end
end
