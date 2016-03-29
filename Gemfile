source ENV['GEM_SOURCE'] || "https://rubygems.org"

group(:development, :test) do
  gem 'simplecov', :require => false
  gem 'yard', :require => false
  # rubocop breaks stuff every single release, so pinning.
  gem 'rubocop',  '0.39.0'
  gem 'json'
  gem 'redis'
  gem 'rake'
  gem 'minitest'
end
