require 'delegate'

def NamedValueClass(klass_name,superclass,&block)
  target = (self.class == Object ? Kernel : self)
  
  target.module_eval "class #{klass_name} < DelegateClass(superclass); end"
  klass = target.const_get(klass_name)  
  
  klass.module_eval do
    def initialize(name,value)
      @name = name.to_s
      super(value)
      
      # THINK is this making it harder than it needs to be?
      named_values_module = self.class.const_get('NamedValues')
      named_values_collection = named_values_module.const_get('Collection')
      self.class.const_set(@name, self)
      named_values_module.const_set(@name, self)
      named_values_collection << self
    end
    
    def to_s # :nodoc:
      @name
    end
    
    def value_to_s # :nodoc:
      method_missing :to_s
    end
    
    def inspect  # :nodoc:
      @name
    end
    
    def value_inspect # :nodoc:
      method_missing :inspect
    end
    
    class_eval(&block) if block
  end
  
  klass.class_eval <<-EVAL
    module NamedValues
      Collection = []
    end
  EVAL
  
  define_singleton_method klass_name do |name,value| 
    klass.const_get(name) rescue klass.new(name,value)
  end
  
  klass
end
