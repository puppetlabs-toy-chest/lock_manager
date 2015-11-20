require 'redis'
require 'json'

class LockManager
  attr_accessor :host, :user, :redis

  def initialize(redis_server, host, user, redis_port = nil)
    @host = host.split('.')[0]
    @user = user
    @redis = connect_redis(redis_server, redis_port)
  end

  # Create a connection to redis.
  def connect_redis(redis_server, redis_port = 6379)
    r = Redis.new(host: redis_server, port: redis_port)
    r.ping
    r
  end

  def lock(reason = nil)
    if locked?
      puts "#{@host} already locked."
      return false
    end
    unsafe_lock(reason)
  end

  def unsafe_lock(reason = nil)
    lock_contents = {}
    lock_contents[:user] = @user
    lock_contents[:time] = Time.now.to_s
    lock_contents[:reason] = reason
    r = @redis.set "node_lock_#{@host}", lock_contents.to_json
    r == 'OK'
  end

  # Boolean to figure out if a host is locked.
  #
  # @return [Bool] whether or not the host is lockd.
  def locked?
    return true if @redis.get("node_lock_#{@host}")
    false
  end

  def unlock
    r = @redis.get("node_lock_#{@host}")
    if r
      result  = JSON.parse(r)
      if result['user'] != @user
        warn "Refusing to unlock. Lock on #{@host} is owned by #{result['user']}."
      else
        return true if unsafe_unlock.is_a?(Integer)
        return false
      end
    end
    false
  end

  def unsafe_unlock
    @redis.del("node_lock_#{@host}")
  end

  def polling_lock(reason = nil)
    sleep_duration = 1
    loop do
      if locked?
        print "#{@host} is locked..."
        puts "waiting #{sleepcount} seconds."
        sleep sleep_duration
        sleep_duration *= 2
      else
        break
      end
    end
    lock(reason)
  end

  def inspect
    @redis.get("node_lock_#{@host}")
  end
end
