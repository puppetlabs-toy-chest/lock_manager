require 'json'

class LockManager
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def lock(host, user, reason = nil)
    LockManagerWorker.new(connection, host).lock(user, reason)
  end

  def polling_lock(host, user, reason = nil)
    LockManagerWorker.new(connection, host).polling_lock(user, reason)
  end

  def unlock(host, user)
    LockManagerWorker.new(connection, host).unlock(user)
  end

  def locked?(host)
    LockManagerWorker.new(connection, host).locked?
  end

  def show(host)
    LockManagerWorker.new(connection, host).show
  end

  def connection
    fail ArgumentError, ':type option is required' unless options[:type]
    @connection ||= LockManagerConnection.connection_class(options[:type]).new(options)
  end
end

class LockManagerConnection
  attr_reader :options

  def self.connection_class(type)
    case type.to_s
    when 'redis'
      LockManagerRedisConnection
    else
      fail ArgumentError, "Unknown connection type: #{type}"
    end
  end

  def initialize(options = {})
    @options = options
  end

  def write(key, value)
    fail "Not implemented: write(#{key}, #{value})"
  end

  def read(key)
    fail "Not implemented: read(#{key})"
  end

  def remove(key)
    fail "Not implemented: remove(#{key})"
  end
end

require 'redis'

class LockManagerRedisConnection < LockManagerConnection
  attr_reader :server, :port

  def initialize(options = {})
    super
    fail ArgumentError, ':server option is mandatory for redis connections' unless options[:server]
    @server = options[:server]
    @port = options[:port]
  end

  def read(host)
    handle.get key_from_host(host)
  end

  def write(host, value)
    handle.set(key_from_host(host), value)
  end

  def remove(host)
    handle.del key_from_host(host)
  end

  def key_from_host(host)
    "node_lock_#{host}"
  end

  def handle
    @handle ||= connect_redis(server, port)
  end

  # Create a connection to redis.
  def connect_redis(redis_server, redis_port = 6379)
    redis = Redis.new(host: redis_server, port: redis_port)
    redis.ping
    redis
  end
end

class LockManagerWorker
  attr_reader :connection, :host, :user

  def initialize(connection, host)
    @connection = connection
    @host = host.split('.')[0]
    @user = user
  end

  def lock(user, reason = nil)
    if locked?
      log "#{host} already locked."
      return false
    end
    lock!(user, reason)
  end

  def lock!(user, reason = nil)
    lock_contents = {
      user:  user,
      time: Time.now.to_s,
      reason: reason
    }
    r = connection.write host, lock_contents.to_json
    r == 'OK'
  end

  # Boolean to figure out if a host is locked.
  #
  # @return [Bool] whether or not the host is lockd.
  def locked?
    !!connection.read(host)
  end

  def unlock(user)
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
    connection.remove(host) > 0
  end

  def lock_user
    lock_data = connection.read host
    return false unless lock_data
    result = JSON.parse lock_data
    result['user']
  end

  def polling_lock(user, reason = nil)
    sleep_duration = 1
    loop do
      if locked?
        log "#{host} is locked..."
        log "waiting #{sleep_duration} seconds."
        sleep sleep_duration
        sleep_duration *= 2
      else
        break
      end
    end
    lock(user, reason)
  end

  def show
    data = connection.read(host)
    data ? JSON.parse(data) : nil
  end

  def log(message)
    warn message
  end
end
