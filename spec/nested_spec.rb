require 'helpers/helper'
require 'named_value_class'

module Outer
  module Inner
    eval File.read('spec/helpers/foobar.rb')
    describe 'within a nested module' do
      eval File.read('spec/helpers/specs.rb')
    end
  end
end

include Outer::Inner
describe 'included nested module' do
  eval File.read('spec/helpers/specs.rb')
end
