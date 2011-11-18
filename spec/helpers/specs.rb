describe 'NamedValueClass' do
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