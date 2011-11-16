$:.unshift File.join( File.dirname( __FILE__ ))
$:.unshift File.join( File.dirname( __FILE__ ), 'lib')

require 'rake'
require 'rake/testtask'
require 'named_value_class'

Rake::TestTask.new(:test) do |t|
  t.libs << "spec"
  t.test_files = FileList["spec/**/*_spec.rb"]
  t.verbose = true
end

task :build do
  system "gem build named_value_class.gemspec"
end
 
task :local => :build do
  system "gem install named_value_class-0.2.0.gem"
end

task :release => :build do
  system "gem push named_value_class-0.2.0.gem"
end

task :default => [:test]
