require 'delegate'
require 'named_value_class/core_ext'

module NamedValueClass
  OPERATIONS = {}
  # OPERATORS = %w{+ - / * ** % | & ^ << >>}
  OPERATORS = %w{+ - / * **}
  
  def self.operators(klass, op, rhs_class, policy)
    rhs_class = rhs_class.sub(/^Kernel::/,'')
    OPERATIONS[klass] ||= {}
    OPERATIONS[klass][rhs_class] ||= {}
    OPERATIONS[klass][rhs_class][op] = policy
  end

  def self.operate(klass, op, rhs_class, lhs, default_policy, rhs)
    rhs_class = rhs_class.sub(/^Kernel::/,'')
    result = (OPERATIONS[klass] && OPERATIONS[klass][rhs_class] &&
              OPERATIONS[klass][rhs_class][op]) ?
             OPERATIONS[klass][rhs_class][op].call(lhs,default_policy,rhs) :
             default_policy.call(rhs)
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
    
    def self.all_operators_with_a *attrs
      rhs_class = attrs.shift
      operators *(NamedValueClass::OPERATORS + [rhs_class] + attrs)
    end
    
    def self.all_remaining_operators_with_a *attrs
    end
    
    def self.operators *attrs, &block
      policy = attrs.pop if attrs.last.is_a?(Hash) 
      with_a = attrs.pop
      attrs.each do |op|
        operator op, *([with_a, policy].compact), &block
      end
    end
    
    def self.operator op, rhs_class, attrs={}, &policy
      if value_to_return = (attrs[:return] || attrs[:returns])
        policy = proc do |_,_,_|
          value_to_return
        end
      end
      if klass_to_raise = (attrs[:raise] || attrs[:raises])
        policy = proc do |_,_,_|
          raise klass_to_raise
        end
      end
      NamedValueClass.operators(self, op, rhs_class.to_s, policy)
    end

    def self.plus_a         (*attrs,&policy) operator '+', *attrs, &policy end
    def self.minus_a        (*attrs,&policy) operator '-', *attrs, &policy end
    def self.divided_by_a   (*attrs,&policy) operator '/', *attrs, &policy end
    def self.multiplied_by_a(*attrs,&policy) operator '*', *attrs, &policy end
    def self.modulus_a      (*attrs,&policy) operator '%', *attrs, &policy end
    def self.raised_by_a    (*attrs,&policy) operator '**',*attrs, &policy end

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
    #     if @operators && @operators[rhs.class]
    #       @operators[rhs.class].call(self,rhs)
    #     end
    #   end
    # end
  
    attr_reader :value
    
    def initialize(attrs = {})
      @name, value = attrs.first
      attrs.delete(@name)
      @name = @name.to_s
      super(@value = value)

      this = self
      attrs.each do |(attr,val)|
        self.class.instance_eval do
          attr_accessor attr
          if [FalseClass,TrueClass].include?(val.class)
            booleans = begin
              const_get((attr.to_s+'s').upcase)
            rescue NameError
              const_set((attr.to_s+'s').upcase, {})
            end
            
            booleans[value] = this if val
            
            self.class.instance_eval do
              define_method(attr.to_s + 's') do
                const_get((attr.to_s+'s').upcase)
              end
            end
            define_method "is_#{attr}?" do
              self.send(attr)
            end
          end
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
