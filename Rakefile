require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"
require "rubocop/rake_task"

desc "Test lock_manager"
namespace :test do
  Rake::TestTask.new(:spec) do |test|
    test.libs << "test"
    test.pattern = "test/**/*_spec.rb"
    test.verbose = true
    test.warning = true
  end

  desc "Test lock_manager and calculate test coverage"
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["test:spec"].invoke
  end
end

desc "Run RuboCop"
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ["lib/**/*.rb"]
end

desc "Run all spec tests and linters"
task check: %w(test:spec rubocop)

task default: [ :check, :test]
