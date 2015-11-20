require 'minitest/autorun'
require 'lock_manager'

class TestLockManagerRedisConnect < MiniTest::Test
  def test_connect_good
    @rlm = LockManager.new('localhost', 'pe-aix-72-builder', 'stahnma')
    assert_instance_of(LockManager, @rlm)
    @rlm.lock
    assert_instance_of(Hash, JSON.parse(@rlm.inspect))
    @rlm.unlock
  end

  def test_bogus_connect
    assert_raises(SocketError) do
      LockManager.new('nopehost', 'pe-aix-72-builder', 'stahnma')
    end
  end
end
