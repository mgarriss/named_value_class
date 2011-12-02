describe Foo do
  it 'has constants F1 and F2 set as instances of Foo' do
    Foo::F1.class.must_equal Foo
    Foo::F2.class.must_equal Foo
  end
  
  it 'sets F1' do
    Foo::F1.must_equal 1
  end
  
  it 'sets F2' do
    Foo::F2.must_equal 2
    Foo::F2.must_equal 2
  end
  
  it 'set ff' do
    Foo::ff.must_equal 36
  end
  
  describe '#foo' do
    it 'is listed in .instance_methods' do
      Foo.instance_methods.must_include :foo
    end
    
    it 'returns' do
      Foo::F1.foo.must_equal 5
    end
  end
  
  describe '#to_s' do
    it 'returns a string equal to the const name' do
      Foo::F1.to_s.must_equal 'F1'
      Foo::F2.to_s.must_equal 'F2'
    end
  end
  
  describe '#inspect' do
    it 'returns a string equal to the const name' do
      Foo::F1.inspect.must_equal 'F1'
      Foo::F2.inspect.must_equal 'F2'
    end
  end
  
  describe '#value_to_s' do
    it 'calls the values #to_s' do
      Foo::F1.value_to_s.must_equal '1'
      Foo::F2.value_to_s.must_equal '2'
    end
  end
  
  describe '#value_inspect' do
    it 'calls the values #inspect' do
      Foo::F1.value_inspect.must_equal '1'
      Foo::F2.value_inspect.must_equal '2'
    end
  end
  
  describe '.[]' do
    it 'returns the constant with the given value' do
      Foo[1].to_s.must_equal 'F1'
      Foo[1].must_equal 1
    end
    
    it 'returns the first mapping set, not the last' do
      Foo[2].to_s.must_equal 'F2'
      Foo[2].must_equal 2
    end
  end
end

describe Bar do
  it 'included all the Foo named values' do
    Bar::F1.must_equal 1
    Bar::F2.must_equal 2
  end
end

describe Foo::NamedValues do
  it 'is a Module' do
    Foo::NamedValues.must_be_instance_of Module
  end
  
  describe Foo::NamedValues::Collection do
    it 'is an Array' do
      Foo::NamedValues::Collection.must_be_instance_of Array
    end
  end
  
  it 'has size 2' do
    Foo::NamedValues::Collection.size.must_equal 4
  end
  
  it 'includes F1' do
    Foo::NamedValues::Collection.must_include Foo::F1
  end
  
  it 'includes F2' do
    Foo::NamedValues::Collection.must_include Foo::F2
  end
  
  it 'includes ff' do
    Foo::NamedValues::Collection.must_include Foo::ff
  end
  
  it 'provides ff in Foo and in Foo::NamedValues' do
    Foo::ff.must_equal 36
    Foo::NamedValues::ff.must_equal Foo::ff
  end
end

describe 'NamedValueClass additional attributes' do
  it 'is accessable from any instance' do
    Baz::B1.param_a.must_equal 'dude'
    Baz::B1.param_b.must_equal 5
    Baz::B1.param_c.must_be_nil
    
    Baz::B2.param_a.must_equal 'dude2'
    Baz::B2.param_b.must_be_nil
    Baz::B2.param_c.must_be_nil
    
    Baz::B3.param_a.must_be_nil
    Baz::B3.param_b.must_equal 58
    
    Baz::B4.param_a.must_be_nil
    Baz::B4.param_b.must_be_nil
    Baz::B4.param_c.must_equal 'YA'
  end
  
  it 'acts like an Array' do
    Baz::B1[0].must_equal 1
    Baz::B1[1].must_equal 2
    
    Baz::B2[0].must_be_nil
    Baz::B2[1].must_be_nil
  end
  
  it 'has a working setter' do
    Baz::B3.param_c = 45
    Baz::B3.param_c.must_equal 45
  end
end

# describe 'constant:true' do
#   %w[= += -= *= /= **= %= |= ^= &= <<= >>= &&= ||=].each do |op|
#     describe op.to_s do
#       it 'raises SyntaxError' do
#         skip "can't overload assignment; will these ever pass? don't do Foo::ff #{op} 1"
#         proc do
#           eval "Foo::F1 #{op} 4"
#         end.must_raise SyntaxError
#         proc do
#           eval "Foo::F1 #{op} Foo::F2"
#         end.must_raise SyntaxError
#         proc do
#           eval "Biz1 #{op} Foo::F2"
#         end.must_raise SyntaxError
#         proc do
#           eval "Foo::ff #{op} 4"
#         end.must_raise SyntaxError
#       end
#     end
#   end
# end

describe '.operation' do
  it 'accepts a symbol for rhs name' do
    (Foo::F1 - Biz::Biz1).must_equal 0
    (Foo::ff - Biz::Biz1).must_equal 35
  end
  it 'accepts a string for rhs name' do
    (Foo::F1 + Biz::Biz1).must_equal 'big big baz'
    (Foo::ff + Biz::Biz2).must_equal 'big big baz'
  end
  describe 'Biz + Foo' do
    it 'just does a default +' do
      (Biz::Biz1 + Foo::F1).must_equal(Biz::Biz1.value + Foo::F1.value)
      (Biz::Biz1 + Foo::ff).must_equal(Biz::Biz1.value + Foo::ff.value)
    end
  end
  describe 'Biz + String' do
    it 'performs a String * Biz' do
      (Biz::Biz1 + "A").must_equal "A"
      (Biz::Biz2 + "A").must_equal "AA"
    end
  end
  describe 'Biz - String' do
    it 'performs a String * Biz * 2' do
      (Biz::Biz1 - "A").must_equal "AA"
      (Biz::Biz2 - "A").must_equal "AAAA"
    end
  end
  describe 'Biz - Biz' do
    it 'returns "just odd"' do
      (Biz::Biz1 - Biz::Biz1).must_equal "just odd"
      (Biz::Biz2 - Biz::Biz1).must_equal "just odd"
    end
  end
  # describe 'Biz - Foo' do
  #   it 'performs a Foo - Biz' do
  #     skip "still scratching my head why the policy closure is never called..."
  #     (Biz::Biz1 - Foo::F1).must_equal 0
  #     (Biz::Biz1 - Foo::F2).must_equal 1
  #     (Biz::Biz2 - Foo::ff).must_equal 34
  #   end
  # end
end

describe 'returning a Mapping constant of lhs if possible' do
  describe 'Foo::F2 - 1' do
    it 'returns Foo::F1 and not 1' do
      (Foo::F2 - 1).to_s.must_equal 'F1'
    end
  end
  describe 'Foo::F2 - 0' do
    it 'returns Foo::F2 and not 2' do
      (Foo::F2 - 0).to_s.must_equal 'F2'
    end
  end
  describe 'Foo::F1 + 1' do
    it 'returns Foo::F2 and not 2' do
      (Foo::F1 + 1).to_s.must_equal 'F2'
    end
  end
  describe 'Foo::F1 + 0' do
    it 'returns Foo::F1 and not 1' do
      (Foo::F1 + 0).to_s.must_equal 'F1'
    end
  end
end

describe 'constrain' do
  it 'forces a Foo to be at least -10' do
    (Foo::F1 - 1000).must_equal -10
    (Foo::ff - 1000).must_equal -10
  end
  
  it 'forces a Foo to be at most 50' do
    (Foo::F2 + 1000).must_equal 50
    (Foo::ff + Foo::ff).must_equal 50
    (Foo::ff + 1000).must_equal 50
  end
end

describe '#is_(boolean)?' do
  it 'is defined for instances that set a parameters to true or false' do
    Foo::F1.is_prime?.must_equal true
    Foo::F2.is_prime?.wont_equal true
    Foo::ff.is_even?.must_equal true
    Foo::fff.is_even?.must_equal true
  end
end

describe '.(booleans)' do
  it 'is defined for classes with instances that set a parameters to true or false' do
    Foo.primes.must_be_instance_of Hash
    Foo.evens.must_be_instance_of Hash
    
    Foo.primes.must_equal({1=>Foo::F1})
    Foo.evens.must_equal({36=>Foo::ff,16=>Foo::fff})
  end
end

describe "operations '+', '-', '%' ...." do
  it 'sets the same policy to all listed operators' do
    (Biz1 +  Biz2).must_equal (Biz1 +  Biz1)
    (Biz1 /  Biz2).must_equal (Biz1 /  Biz1)
    (Biz1 ** Biz2).must_equal (Biz1 ** Biz1)
    (Biz1 +  Biz2).must_equal (Biz1 +  Biz1)
  end
end

describe NamedValueClass::OPERATORS do
  it 'is an Array containing all Operators' do
    # %w{+ - / * ** % | & ^ << >>}.each do |operator|
    %w{+ - / * **}.each do |operator|
      NamedValueClass::OPERATORS.must_include operator
    end
  end
end

describe 'all_operations_with_a' do
  it 'set the same policy for all operators with given class on rhs' do
    NamedValueClass::OPERATORS.each do |operator|
      proc {eval "P1 #{operator} P2"}.must_raise SyntaxError
    end
  end
end

describe 'all_remaining_operators_with_a' do
  it "sets all remaining undefined operators to the given policy" do
    (P1 * R1).must_equal 'here'
    (NamedValueClass::OPERATORS - ['*']).each do |operator|
      proc {eval "P1 #{operator} R1"}.must_raise SyntaxError
    end
  end
end

describe 'operation .... raise(s):Something' do
  it 'sets a policy of always raising what ever class is provided' do           
    # proc {Biz1 ** Foo::ff}.must_raise SyntaxError
  end
end

describe 'operation .... return(s):Something' do
  it 'returns the give object as the policy' do
    NamedValueClass::OPERATORS.each do |operator|
      (eval "R1 #{operator} R2").must_equal 'Dude'
    end
  end
end
