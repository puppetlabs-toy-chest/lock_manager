require 'redis'
require 'json'

DEFAULT_LOCK_USER = ENV['LOCK_USER'] || ENV['USER']

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
    r = @redis.set "node_lock_#{@host.split('.')[0]}", lock_contents.to_json
    if r == 'OK'
      true
    else
      false
    end
  end

  # Boolean to figure out if a host is locked.
  #
  # @return [Bool] whether or not the host is lockd.
  def locked?
    return true if @redis.get("node_lock_#{@host.split('.')[0]}")
    false
  end

  def unlock
    r = @redis.get("node_lock_#{@host.split('.')[0]}")
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
    @redis.DEL("node_lock_#{@host.split('.')[0]}")
  end

  def polling_lock(reason = nil)
    if locked?
      sleepcount = 1
      psleepcount = 1
      while locked?
        print "#{@host} is locked..."
        puts "waiting #{sleepcount} seconds."
        sleep sleepcount
        temp = sleepcount
        sleepcount += psleepcount
        psleepcount = temp
      end
    end
    lock(reason)
  end

  def inspect
    @redis.get("node_lock_#{@host}")
  end
end
