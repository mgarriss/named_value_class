require 'helper'
require 'named_value_class'

module Test
  NamedValueClass 'Foo', Fixnum do
    def foo
      5
    end
  end
  
  Foo 'F1', 1
  Foo 'F2', 2
  Foo 'F1', 3 # won't be reset to 3 because F1 is already set to 1
  
  Foo 'ff', 36 # lower case constant
  
  class Bar
    include Foo::NamedValues
  end
end

NamedValueClass 'Foo', Fixnum do
  def foo
    10
  end
end

Foo 'F1', 4
Foo 'F2', 5
Foo 'F1', 6 # won't be reset to 6 because F1 is already set to 4

Foo 'ff', 56 # lower case constant

class Bar
  include Foo::NamedValues
end

describe 'NamedValueClass' do
  describe Foo do
    it 'has constants F1 and F2 set as instances of Foo' do
      Test::Foo::F1.class.must_equal Test::Foo
      Test::Foo::F2.class.must_equal Test::Foo
      
      Foo::F1.class.must_equal Foo
      Foo::F2.class.must_equal Foo
    end
    
    it 'sets F1' do
      Test::Foo::F1.must_equal 1
      Foo::F1.must_equal 4
    end
    
    it 'sets F2' do
      Test::Foo::F2.must_equal 2
      Foo::F2.must_equal 5
      Foo::F2.must_equal 5
    end
    
    it 'set ff' do
      Test::Foo::ff.must_equal 36
      Foo::ff.must_equal 56
    end
    
    describe '#foo' do
      it 'is listed in .instance_methods' do
        Test::Foo.instance_methods.must_include :foo
        Foo.instance_methods.must_include :foo
      end
      
      it 'returns' do
        Test::Foo::F1.foo.must_equal 5
        Foo::F1.foo.must_equal 10
      end
    end
    
    describe '#to_s' do
      it 'returns a string equal to the const name' do
        Test::Foo::F1.to_s.must_equal 'F1'
        Test::Foo::F2.to_s.must_equal 'F2'
        
        Foo::F1.to_s.must_equal 'F1'
        Foo::F2.to_s.must_equal 'F2'
      end
    end
    
    describe '#inspect' do
      it 'returns a string equal to the const name' do
        Test::Foo::F1.inspect.must_equal 'F1'
        Test::Foo::F2.inspect.must_equal 'F2'
        
        Foo::F1.inspect.must_equal 'F1'
        Foo::F2.inspect.must_equal 'F2'
      end
    end
    
    describe '#value_to_s' do
      it 'calls the values #to_s' do
        Test::Foo::F1.value_to_s.must_equal '1'
        Test::Foo::F2.value_to_s.must_equal '2'
        
        Foo::F1.value_to_s.must_equal '4'
        Foo::F2.value_to_s.must_equal '5'
      end
    end
    
    describe '#value_inspect' do
      it 'calls the values #inspect' do
        Test::Foo::F1.value_inspect.must_equal '1'
        Test::Foo::F2.value_inspect.must_equal '2'
        
        Foo::F1.value_inspect.must_equal '4'
        Foo::F2.value_inspect.must_equal '5'
      end
    end
    
    describe '.[]' do
      it 'returns the constant with the given value' do
        Test::Foo[1].to_s.must_equal 'F1'
        Test::Foo[1].must_equal 1
        Test::Foo[2].to_s.must_equal 'F2'
        Test::Foo[2].must_equal 2
        
        Foo[4].to_s.must_equal 'F1'
        Foo[4].must_equal 4
        Foo[5].to_s.must_equal 'F2'
        Foo[5].must_equal 5
      end
    end
  end
  
  describe Bar do
    it 'included all the Foo named values' do
      Test::Bar::F1.must_equal 1
      Bar::F1.must_equal 4
      Test::Bar::F2.must_equal 2
      Bar::F2.must_equal 5
    end
  end
  
  describe Foo::NamedValues do
    it 'is a Module' do
      Test::Foo::NamedValues.must_be_instance_of Module
      Foo::NamedValues.must_be_instance_of Module
    end
    
    describe Foo::NamedValues::Collection do
      it 'is an Array' do
        Test::Foo::NamedValues::Collection.must_be_instance_of Array
        Foo::NamedValues::Collection.must_be_instance_of Array
      end
    end
    
    it 'has size 2' do
      Test::Foo::NamedValues::Collection.size.must_equal 3
      Foo::NamedValues::Collection.size.must_equal 3
    end
    
    it 'includes F1' do
      Test::Foo::NamedValues::Collection.must_include Test::Foo::F1
      Foo::NamedValues::Collection.must_include Foo::F1
      
      Test::Foo::NamedValues::Collection.wont_include Foo::F1
      Foo::NamedValues::Collection.wont_include Test::Foo::F1
    end
    
    it 'includes F2' do
      Test::Foo::NamedValues::Collection.must_include Test::Foo::F2
      Foo::NamedValues::Collection.must_include Foo::F2
      
      Test::Foo::NamedValues::Collection.wont_include Foo::F2
      Foo::NamedValues::Collection.wont_include Test::Foo::F2
    end
    
    it 'includes ff' do
      Test::Foo::NamedValues::Collection.must_include Test::Foo::ff
      Foo::NamedValues::Collection.must_include Foo::ff
      
      Test::Foo::NamedValues::Collection.wont_include Foo::ff
      Foo::NamedValues::Collection.wont_include Test::Foo::ff
    end
    
    it 'provides ff in Foo and in Foo::NamedValues' do
      Test::Foo::NamedValues::ff.must_equal Test::Foo::ff
      Foo::NamedValues::ff.must_equal Foo::ff
    end
  end
end

NamedValueClass 'Baz', Array

Baz 'B1', [1,2], param_a:'dude', param_b:5
Baz 'B2', [],    param_a:'dude2'
Baz 'B3', [2,1], param_b:58
Baz 'B4', [2,1], param_c:'YA'

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
