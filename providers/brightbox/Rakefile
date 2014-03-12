require "bundler/gem_tasks"
require "rake/testtask"

task :default => :test

Rake::TestTask.new do |t|
  t.pattern = File.join("test", "**", "*_test.rb")
end
