require 'json'
require 'lock_manager/worker'
require 'lock_manager/connection'

class LockManager
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def lock(host, user, reason = nil, ttl = nil)
    LockManager::Worker.new(connection, host).lock(user, reason, ttl)
  end

  def polling_lock(host, user, reason = nil)
    LockManager::Worker.new(connection, host).polling_lock(user, reason)
  end

  def unlock(host, user)
    LockManager::Worker.new(connection, host).unlock(user)
  end

  def locked?(host)
    LockManager::Worker.new(connection, host).locked?
  end

  def show(host)
    LockManager::Worker.new(connection, host).show
  end

  def add_resource(platform_tag, host)
    LockManager::Worker.new(connection, host).add_resource(platform_tag, host)
  end

  def remove_resource(platform_tag, host)
    LockManager::Worker.new(connection, host).remove_resource(platform_tag, host)
  end

  def pool_members(platform_tag)
    host = 'dummy'
    LockManager::Worker.new(connection, host).pool_members(platform_tag)
  end

  def acquire_lock(platform_tag, user, reason = nil, ttl = nil)
    host = 'dummy'
    LockManager::Worker.new(connection, host).acquire_lock(platform_tag, user, reason, ttl)
  end

  def connection
    raise ArgumentError, ':type option is required' unless options[:type]
    @connection ||= LockManager::Connection.connection_class(options[:type]).new(options)
  end
end
