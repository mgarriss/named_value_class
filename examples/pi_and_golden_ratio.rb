#!/usr/bin/env ruby
$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "named_value_class"

module MyApp
  NamedValueClass 'MathFloat', Float
  
  MathFloat 'Pi',  3.14159265358979323846
  MathFloat 'Phi', 1.61803398874989
end

include MyApp::MathFloat::NamedValues

# an IRB run with output given after '#=>':

# the following 2 output the constant's name and not the underlying value
Pi                #=> Pi
Phi               #=> Phi

# the following 3 output a value because the results are regular Floats 
Pi / 2            #=> 1.5707963267948966
Phi / 2           #=> 0.809016994374945
Pi + Phi          #=> 4.759626642339683

# showing constant names here, note that is output is eval'able
[Pi, Phi]         #=> [Pi, Phi]

Phi.value_inspect #=> "1.61803398874989"
