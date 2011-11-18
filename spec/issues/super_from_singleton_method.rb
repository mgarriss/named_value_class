require 'helpers/helper'

module Inner
  NamedValueClass A:Fixnum
  A A1:1
  A A2:2
  NamedValueClass B:Fixnum
  B B1:3
  B B2:4
end

NamedValueClass C:Fixnum 
2.times do
  C :c => :c
end


