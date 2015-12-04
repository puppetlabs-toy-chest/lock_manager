require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'test'
  t.pattern = 'test/**/*.rb'
  t.warning = true
  t.verbose = true
end

task :default => [ :check, :test]

desc "Rubocop"
task :check do
  sh 'rubocop'
end
