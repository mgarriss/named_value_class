require 'helpers/helper'
require 'named_value_class'

module Test
  eval File.read('spec/helpers/foobar.rb')
  describe 'within a module' do
    eval File.read('spec/helpers/specs.rb')
  end
end

include Test
describe 'included module' do
  eval File.read('spec/helpers/specs.rb')
end
