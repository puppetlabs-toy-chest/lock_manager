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

  def log(message)
    warn message
  end

  def lock(reason = nil)
    if locked?
      log "#{host} already locked."
      return false
    end
    lock!(reason)
  end

  def lock!(reason = nil)
    lock_contents = {
      user:  @user,
      time: Time.now.to_s,
      reason: reason
    }
    r = redis.set lock_handle, lock_contents.to_json
    r == 'OK'
  end

  # Boolean to figure out if a host is locked.
  #
  # @return [Bool] whether or not the host is lockd.
  def locked?
    !!redis.get(lock_handle)
  end

  def lock_handle
    "node_lock_#{host}"
  end

  def lock_user
    lock_data = redis.get lock_handle
    return false unless lock_data
    result = JSON.parse lock_data
    result['user']
  end

  def unlock
    if !locked?
      log "Refusing to unlock. No lock exists on #{host}."
      false
    elsif user == lock_user
      unlock!
    else
      log "Refusing to unlock. Lock on #{host} is owned by #{lock_user}."
      false
    end
  end

  def unlock!
    redis.del(lock_handle) > 0
  end

  def polling_lock(reason = nil)
    sleep_duration = 1
    loop do
      if locked?
        print "#{host} is locked..."
        log "waiting #{sleep_duration} seconds."
        sleep sleep_duration
        sleep_duration *= 2
      else
        break
      end
    end
    lock(reason)
  end

  def inspect
    redis.get(lock_handle)
  end
end
