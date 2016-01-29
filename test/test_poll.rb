require 'test_helper'

class TestLockManagerPoll < MiniTest::Test
  def setup
    @rlm = LockManager.new(type: 'redis', server: 'localhost')
    @rlm.unlock 'pe-aix-72-builder', 'stahnma' # clear out any previously set locks
  end

  def test_polling_lock
    assert @rlm.polling_lock('pe-aix-72-builder', 'stahnma')
  end

  def test_polling_lock_when_locked_already
    assert_raises Timeout::Error do
      Timeout.timeout(3) do
        @rlm.lock('pe-aix-72-builder', 'stahnma')
        @rlm.polling_lock('pe-aix-72-builder', 'stahnma')
      end
    end

    assert @rlm.locked?('pe-aix-72-builder')
  end
end
