NamedValueClass Foo:Fixnum do
  def foo
    5
  end
end

Foo F1:1
Foo F2:2
Foo F1:3
Foo ff:36
Foo fff:16

class Bar
  include Foo::NamedValues
end

NamedValueClass Baz:Array

Baz B1:[1,2], param_a:'dude', param_b:5
Baz B2:[],    param_a:'dude2'
Baz B3:[2,1], param_b:58
Baz B4:[2,1], param_c:'YA'
