require 'minitest/autorun'
require 'json'
require 'lock_manager'
require 'lock_manager/connection'
require 'lock_manager/worker'
require 'lock_manager/redis_connection'

class LockManager
  class Worker
    def log(*)
    end
  end
end
