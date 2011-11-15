$:.unshift File.join( File.dirname( __FILE__ ))
$:.unshift File.join( File.dirname( __FILE__ ), 'lib')

spec = Gem::Specification.new do |s|
  s.name     = 'named_value_class'
  s.version  = '0.1.0'
  s.summary  = 'Quickly add class delegate constants which output their names, not their values.  This may be desirable for some DSLs.'
  s.files    = Dir['lib/named_value_class.rb']
  s.author   = "Michael Garriss"
  s.email    = "mgarriss@gmail.com"
  s.homepage = "http://github.com/mgarriss/named_value_class"
  
  s.require_path = 'lib'
end
