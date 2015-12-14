require 'redis'

class LockManager
  class RedisConnection < LockManager::Connection
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

    def write_if_not_exists(host, value)
      handle.setnx(key_from_host(host), value)
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
end
