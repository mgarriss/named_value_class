# NamedValueClass Foo:Fixnum, constrain:-10..50 do
#   minus_a :Biz do |foo,minus,biz|
#     minus.call biz
#   end
  
#   plus_a 'Biz' do |foo,_,baz|
#     'big big baz'
#   end
  
#   def foo
#     5
#   end
# end

# Foo F1:1,   prime:true
# Foo F2:2
# Foo F1:3,   prime:true
# Foo ff:36,  even:true
# Foo fff:16, prime:false, even:true

# class Bar
#   include Foo::NamedValues
# end

# NamedValueClass Baz:Array

# Baz B1:[1,2],   param_a:'dude', param_b:5                                       
# Baz B2:[],      param_a:'dude2'
# Baz B3:[2,1],   param_b:58
# Baz B4:[2,1],   param_c:'YA'
# Baz b4:[2,1,3]

# NamedValueClass Biz:Float do
#   operator '+', Foo do |biz,plus,foo|
#     plus.call foo
#   end
  
#   operator '**', Foo, raises:SyntaxError
  
#   operator '+', String do |biz,_,string|
#     string * biz
#   end
#   operator '-', String do |biz,_,string|
#     string * biz * 2
#   end
#   operator '-', Biz do |lhs,_,rhs|
#     "just odd"
#   end
#   operator '-', Baz do |biz,minus,foo|
#     foo - biz
#     'hella weird'
#   end
#   operators '+', '/', '**', Biz do |lhs,op,rhs|
#     op.call lhs
#   end
# end
# Biz Biz1:1.0
# Biz Biz2:2.3

# include Biz::NamedValues

# NamedValueClass Pop:Fixnum do
#   all_operators_with_a Pop, raise:SyntaxError
# end
# Pop P1:1
# Pop P2:2

# include Pop::NamedValues

# NamedValueClass Rot:Fixnum do
#   multiplied_by_a Pop do
#     'here'
#   end
#   all_remaining_operators_with_a Pop, raise:SyntaxError
  
#   divided_by_a Rot, raises:SyntaxError
#   all_operators_with_a Rot, return:'Dude'
# end
# Rot R1:1
# Rot R2:2

# include Rot::NamedValues
