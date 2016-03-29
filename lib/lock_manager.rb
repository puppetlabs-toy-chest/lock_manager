require 'json'
require 'lock_manager/worker'
require 'lock_manager/connection'

class LockManager
  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def lock(host, user, reason = nil)
    LockManager::Worker.new(connection, host).lock(user, reason)
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

  def connection
    raise ArgumentError, ':type option is required' unless options[:type]
    @connection ||= LockManager::Connection.connection_class(options[:type]).new(options)
  end
end
