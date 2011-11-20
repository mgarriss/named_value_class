NamedValueClass Foo:Fixnum, constrain:-10..50 do
  minus_a :Biz do |foo,minus,biz|
    minus biz
  end
  
  plus_a 'Biz' do |foo,_,baz|
    'big big baz'
  end
  
  def foo
    5
  end
end

Foo F1:1,   prime:true
Foo F2:2
Foo F1:3,   prime:true
Foo ff:36,  even:true
Foo fff:16, prime:false, even:true

class Bar
  include Foo::NamedValues
end

NamedValueClass Baz:Array

Baz B1:[1,2],   param_a:'dude', param_b:5
Baz B2:[],      param_a:'dude2'
Baz B3:[2,1],   param_b:58
Baz B4:[2,1],   param_c:'YA'
Baz b4:[2,1,3]

NamedValueClass Biz:Float do
  operation '+', Foo do |biz,plus,foo|
    plus foo
  end
  operation '+', String do |biz,_,string|
    string * biz
  end
  operation '-', String do |biz,_,string|
    string * biz * 2
  end
  operation '-', Biz do |lhs,_,rhs|
    "just odd"
  end
  operation '-', Baz do |biz,minus,foo|
    # foo - biz
    'hella weird'
  end
end
Biz Biz1:1
Biz Biz2:2

include Biz::NamedValues
