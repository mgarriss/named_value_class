require 'spec_helper'
require 'named_value_class'

module Outer
  module Inner
    eval File.read('examples/foobar.rb')
    describe 'within a nested module' do
      eval File.read('spec/_specs.rb')
    end
  end
end

include Outer::Inner
describe 'included nested module' do
  eval File.read('spec/_specs.rb')
end
