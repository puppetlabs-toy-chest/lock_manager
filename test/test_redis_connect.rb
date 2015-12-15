require 'test_helper'

class TestLockManagerRedisConnect < MiniTest::Test
  def test_connect_good
    @rlm = LockManager.new(type: 'redis', server: 'localhost')
    assert_instance_of(LockManager, @rlm)
    @rlm.lock('pe-aix-72-builder', 'stahnma')
    lock_data = @rlm.show('pe-aix-72-builder')
    assert_equal 'stahnma', lock_data['user'], 'Expected user to be properly set'
    @rlm.unlock('pe-aix-72-builder', 'stahnma')
  end

  def test_bogus_connect
    assert_raises(SocketError) do
      @rlm = LockManager.new(type: 'redis', server: 'nopehost')
      @rlm.locked?('pe-aix-72-builder')
    end
  end
end
