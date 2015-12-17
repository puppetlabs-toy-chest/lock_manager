require 'time'

Gem::Specification.new do |gem|
  gem.name    = 'lock_manager'
  gem.version = %x(git describe --tags).gsub('-', '.').chomp
  gem.date    = Date.today.to_s

  gem.summary = 'Simply system for locking and unlocking hardware resources.'
  gem.description = 'A simple interface for locking hardware resources available via ruby and backed by redis.'
  gem.license = 'Apache-2.0'

  gem.authors  = ['Puppet Labs']
  gem.email    = 'info@puppetlabs.com'
  gem.homepage = 'http://github.com/puppetlabs/lock_manager'
  gem.specification_version = 3
  gem.required_ruby_version = '~> 2.1'

  gem.add_development_dependency('yard', '~> 0.8')
  gem.add_development_dependency('minitest')
  gem.add_runtime_dependency('redis', '>= 3.2')
  gem.require_path = 'lib'

  gem.files = Dir['lib/**/*.rb', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")
  gem.test_files = Dir['test/**/*.rb']
end
