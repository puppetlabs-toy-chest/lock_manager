require 'lock_manager/connection'
require 'resolv'
class LockManager
  class Worker
    attr_reader :connection, :host, :user

    def initialize(connection, host)
      @connection = connection
      if host =~ Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex)
        fail ArgumentError, 'Please use a DNS name rather than an IP address.'
      else
        # Using the shortname of the host has the downside of being unable to
        # lock two hosts with the same shortname and different domains.
        # However, since the majority of users interact with shortname only,
        # we're using shortname to normalize and prevent the system from
        # allowing a lock on aixbuilder1 if aixbuilder1.delivery.puppetlabs.net
        # is locked.
        @host = host.split('.')[0]
      end
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
    # @return [Bool] whether or not the host is locked.
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
end
