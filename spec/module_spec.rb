require 'spec_helper'
require 'named_value_class'

module Test
  eval File.read('examples/foobar.rb')
  describe 'within a module' do
    eval File.read('spec/_specs.rb')
  end
end

include Test
describe 'included module' do
  eval File.read('spec/_specs.rb')
end
