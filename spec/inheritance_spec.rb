require 'helpers/helper'

NamedValueClass 'Goo', String
Goo 'B1', 'this'

class Ber < Goo; end

Ber 'Z1', 'that'
Ber 'Z2', 'those'

module This
  NamedValueClass 'Goo2', String
  Goo2 'B1', 'this'

  class Ber2 < Goo2; end
  
  Ber2 'Z1', 'that'
  Ber2 'Z2', 'those'
end

module That
  module Those
    NamedValueClass 'Goo3', String
    Goo3 'B1', 'this'

    class Ber3 < Goo3; end
    
    Ber3 'Z1', 'that'
    Ber3 'Z2', 'those'
  end
end

describe 'inhertance' do
  it 'creates a new helper method for child classes' do
    Goo::B1.must_equal 'this'
    Ber::Z1.must_equal 'that'
    Ber::Z2.must_equal 'those'
  end
    
  it 'creates a helper under one module' do
    This::Goo2::B1.must_equal 'this'
    This::Ber2::Z1.must_equal 'that'
    This::Ber2::Z2.must_equal 'those'
  end

  it 'creates a helper under double nested modules' do
    That::Those::Goo2::B1.must_equal 'this'
    That::Those::Ber2::Z1.must_equal 'that'
    That::Those::Ber2::Z2.must_equal 'those'
  end
end
