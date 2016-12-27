source ENV['GEM_SOURCE'] || "https://rubygems.org"

gemspec

group(:development, :test) do
  gem 'simplecov', :require => false
  gem 'yard', '~> 0.8', :require => false
  # rubocop breaks stuff every single release, so pinning.
  gem 'rubocop', '0.39.0'
  gem 'json'
  gem 'redis'
  gem 'rake'
  gem 'minitest'
end
