require 'helpers/helper'
require 'named_value_class'

eval File.read('spec/helpers/foobar.rb')
describe 'within kernel' do
  eval File.read('spec/helpers/specs.rb')
end
