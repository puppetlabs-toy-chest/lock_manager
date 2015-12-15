require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'test'
  t.pattern = 'test/**/*.rb'
  t.warning = true
  t.verbose = true
end

task :default => [ :check, :test]

desc "Execute Rubocop checks on the codebase"
task :check do
  sh 'rubocop'
end
