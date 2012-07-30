require 'rubygems'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new(:test) do |t|
  t.pattern = "test/*_test.rb"
end

task :reset do
  `ruby test/test_helper.rb reset_data`
end
