require 'delegate'
require 'named_value_class/core_ext'

module NamedValueClass
  OPERATIONS = {}
  def self.operations(klass, operator, rhs_class, policy)
    rhs_class = rhs_class.sub(/^Kernel::/,'')
    OPERATIONS[klass] ||= {}
    OPERATIONS[klass][rhs_class] ||= {}
    OPERATIONS[klass][rhs_class][operator] = policy
  end
  
  def self.operate(klass, operator, rhs_class, lhs, default_policy, rhs)
    result = begin
      rhs_class = rhs_class.sub(/^Kernel::/,'')
      OPERATIONS[klass][rhs_class][operator].call(lhs,default_policy,rhs)
    rescue NoMethodError
      default_policy.call(rhs)
    end
    result = (result.constrain(lhs.lhs_constrain) rescue result)
    lhs.class[result] || result
  end
end

# see README for documention
def NamedValueClass(attrs={},&block)
  klass_name, superclass = attrs.first
  attrs.delete(klass_name)
  
  lhs_constrain = attrs.delete(:constrain)
  
  target = (self.class == Object ? Kernel : self)
  
  target.module_eval "class #{klass_name} < DelegateClass(superclass); end"
  klass = target.const_get(klass_name)  

  if superclass.ancestors.include?(Numeric) && lhs_constrain
    klass.module_eval <<-EVAL
      def lhs_constrain
        #{lhs_constrain}
      end
    EVAL
  end
  
  klass.module_eval do
    def self.inherited(child)
      super
      code = proc do |attrs={}|
        name, value = attrs.first
        begin
          const_get(name) || const_get("NameError_#{name}")
        rescue NameError #=> e
          child.new(attrs)
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
    
    def self.operation operator, rhs_class, &policy
      NamedValueClass.operations(self, operator, rhs_class.to_s, policy)
    end
    def self.plus_a         (rhs_class,&policy) operation '+', rhs_class, &policy end
    def self.minus_a        (rhs_class,&policy) operation '-', rhs_class, &policy end
    def self.divided_by_a   (rhs_class,&policy) operation '/', rhs_class, &policy end
    def self.multiplied_by_a(rhs_class,&policy) operation '*', rhs_class, &policy end
    def self.modulus_a      (rhs_class,&policy) operation '%', rhs_class, &policy end
    def self.raised_by_a    (rhs_class,&policy) operation '**',rhs_class, &policy end
      
    # class << self
    #   alias plus_an          plus_a
    #   alias minus_an         minus_an
    #   alias divided_by_an    divided_by_a
    #   alias multiplied_by_an multiplied_by_a
    #   alias modulus_an       modulus_a
    #   alias raised_by_an     raised_by_a
    # end
    
    {
     _plus:  '+',
     _minus: '-',
     _multi: '*',
     _divide:'/',
     _mod:   '%',
     _raise: '**'
    }.each do |(name,orig)|
      eval "alias #{name} #{orig}" rescue nil
      define_method orig do |rhs|
        NamedValueClass.operate(self.class,orig,rhs.class.to_s,
                                self,method(name.to_sym),rhs)
      end
    end

    # TODO: think about coerce more
    # def coerce(lhs)
    #   [lhs,self.value]
    # end
         
    # def coerce(rhs)
    #   class_eval do 
    #     if @operations && @operations[rhs.class]
    #       @operations[rhs.class].call(self,rhs)
    #     end
    #   end
    # end
  
    attr_reader :value
    
    def initialize(attrs = {})
      @name, value = attrs.first
      attrs.delete(@name)
      @name = @name.to_s
      super(@value = value)
      
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
  
  define_singleton_method klass_name do |attrs={}| 
    name, value = attrs.first
    begin
      klass.const_get(name) || klass.const_get("NameError_#{name}")
    rescue NameError #=> e
      klass.new(attrs)
    end
  end
  
  klass
end
