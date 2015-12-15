class LockManager
  class Connection
    attr_reader :options

    def self.connection_class(type)
      case type.to_s
      when 'redis'
        require 'lock_manager/redis_connection'
        LockManager::RedisConnection
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
end
