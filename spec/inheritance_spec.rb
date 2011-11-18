require 'helpers/helper'

NamedValueClass 'Goo', String
Goo 'B1', 'this'

class Ber < Goo
end
Ber 'Z1', 'that'
Ber 'Z2', 'those'

describe 'inhertance' do
  it 'creates a new helper method for child classes' do
    Goo::B1.must_equal 'this'
    Ber::Z1.must_equal 'that'
    Ber::Z2.must_equal 'those'
  end
end
