# Lock Manager

Lock manager is designed to be a small helper gem that provides common methods
for locking and unlocking hardware.

## About

Lock manager is a simple gem designed to place a lock on a host via a
json value in redis.

The format for the lock is

    {"user":"stahnma","time":"2015-11-20 05:35:40 +0000",
    "reason":"Becasue reasons"}

## Usage

Create a lock manager object

    a = LockManager.new(type: 'redis', server: 'localhost')

Check to see if the node is locked.

    a.locked? 'pe-aix-72-builder'
    => false

Lock the node

    a.lock 'pe-aix-72-builder', 'stahnma'
    => true

See the lock

    a.show
    => "{\"user\":\"stahnma\",\"time\":\"2015-11-20 05:55:52 +0000\",\"reason\":null}"

Unlock the node

    a.unlock 'pe-aix-72-builder', 'stahnma'
    => true

Lock with a purpose

     a.lock "Because I'm looking into a failure"
     => true

Ask for a lock, if node is already locked, keep trying and wait until you get one

    a.polling_lock('pe-aix-72-builder', 'stahnma')
    pe-aix-72-builder is locked...waiting 1 seconds.
    pe-aix-72-builder is locked...waiting 2 seconds.
    pe-aix-72-builder is locked...waiting 3 seconds.
    pe-aix-72-builder is locked...waiting 5 seconds.
    # Another operations elsewhere unlocked the node
    => true

# Testing

Lock Manager now has tests and rubocop setup. There are basic tests for
the functionality of lock manager.

Tests assume you have redis running on localhost on the default port.

    bundle exec rake

# License
Apache Sofware License 2.0

# Maintainers
Michael Stahnke <stahnma@puppetlabs.com>
Rick Bradley <rick@puppetlabs.com>
