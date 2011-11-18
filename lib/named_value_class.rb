require 'delegate'

def NamedValueClass(klass_name,superclass,&block)
  target = (self.class == Object ? Kernel : self)
  
  target.module_eval "class #{klass_name} < DelegateClass(superclass); end"
  klass = target.const_get(klass_name)  
  
  klass.module_eval do
    def self.inherited(child)
      super
      code = proc do |name,value,attrs={}|
        begin
          const_get(name) || const_get("NameError_#{name}")
        rescue NameError #=> e
          child.new(name,value,attrs)
        end
      end
      if (mod = const_get(self.to_s.sub(/::.+$/,''))) == Kernel
        mod.instance_eval do
          define_method child.to_s.sub(/^.+::/,''), &code
        end
      else
        to_s.split(/::/)[0..-2].inject(Kernel) do |m,e|
          m.const_get(e)
        end.instance_eval do
          module_eval do
            define_singleton_method child.to_s.sub(/^.+::/,''), &code
          end
        end
      end
    end
  
    def initialize(name,value,attrs = {})
      @name = name.to_s
      super(value)
      
      attrs.each do |(attr,val)|
        self.class.instance_eval do
          attr_accessor attr
        end
        instance_variable_set "@#{attr}", val 
      end
      
      named_values_module = self.class.const_get('NamedValues')
      named_values_collection = named_values_module.const_get('Collection')
      
      begin
        self.class.const_set(@name, self)
        named_values_module.const_set(@name, self)
      rescue NameError
        name_error_name = "NameError_#{@name}"
        begin
          self.class.const_get(name_error_name)
        rescue NameError
          self.class.const_set(name_error_name, self)
          named_values_module.const_set(name_error_name, self)
          self.class.class_eval <<-EVAL
            def self.#{@name}()
              #{name_error_name}
            end
          EVAL
          named_values_module.module_eval <<-EVAL
            module NameErrors
              def self.#{@name}()
                #{name_error_name}
              end
              def #{@name}()
                #{name_error_name}
              end
            end
            def #{@name}()
              #{name_error_name}
            end
          EVAL
        end
      end
      
      this = self
      self.class.singleton_class.instance_eval do
        @mapping ||= {}
        @mapping[value] = this unless @mapping[value]
      end
      
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
    
    def self.[](value)
      singleton_class.instance_eval do
        @mapping[value]
      end
    end
    
    class_eval(&block) if block
  end
  
  klass.class_eval <<-EVAL
    module NamedValues
      Collection = []
      def self.included(othermod)
        othermod.class_eval do
          extend NameErrors if defined? NameErrors
        end
        self.class_eval do
          extend NameErrors if defined? NameErrors
        end
      end
    end
  EVAL
  
  define_singleton_method klass_name do |name,value,attrs={}| 
    begin
      klass.const_get(name) || klass.const_get("NameError_#{name}")
    rescue NameError #=> e
      klass.new(name,value,attrs)
    end
  end
  
  klass
end
