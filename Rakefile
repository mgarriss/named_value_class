$:.unshift File.join( File.dirname( __FILE__ ))
$:.unshift File.join( File.dirname( __FILE__ ), 'lib')

require 'rake'
require 'rake/testtask'
require 'named_value_class/version'

Rake::TestTask.new(:test) do |t|
  t.libs << "spec"
  t.test_files = FileList["spec/**/*_spec.rb"] + FileList["spec/issues/*.rb"]
  t.verbose = true
end

task :build do
  system "gem build ../gemspecs/named_value_class.gemspec"
  system "mv named_value_class-#{NamedValueClass::VERSION}.gem ../gems"
end
 
task :local => :build do
  system "gem install ../gems/named_value_class-#{NamedValueClass::VERSION}.gem"
end

task :release => :build do
  system "gem push ../gems/named_value_class-#{NamedValueClass::VERSION}.gem"
end

task :default => [:test]
