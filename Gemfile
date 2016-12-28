source ENV['GEM_SOURCE'] || 'https://rubygems.org'

ruby_version = Gem::Version.new("#{RUBY_VERSION}")
minimum_ruby = Gem::Version.new('2.0.0')

gemspec

group(:development, :test) do
  gem 'simplecov', require: false
  gem 'yard', '~> 0.8', require: false
  # rubocop breaks stuff every single release, so pinning.
  gem 'rubocop', '0.39.0'
  # rubocop depends on rainbow, but rainbow 2.2.0 is a broken
  # release -- don't let rubocop install it.
  gem 'rainbow', '~> 2.1.0'
  # Pin JSON if Ruby isn't at least 2.0.0 -- JSON 2.0.0
  # and up no longer build on Ruby 1.9.3 because 1.9.3
  # is a fossil.
  gem('json', '< 2.0.0') if ruby_version <= minimum_ruby
  gem 'minitest'
  gem 'rake'
end
