require "named_value_class"

module MyApp
  NamedValueClass MathFloat:Float
  MathFloat Pi: 3.14159265358979323846
  MathFloat Phi:1.61803398874989
  
  NamedValueClass Note:Fixnum do
    # this is eval'd in Note's class scope

    attr_reader :some_var

    def play_midi
      # do something interesting here
    end
    
    # maybe define some special cases for subtraction
    alias _minus :-
    def -(rhs)
      if rhs.is_a? String
        "you jammin mon!"
      else
        self._minus(rhs)
      end
    end
  end
  Note A4:440 # Hertz
  Note A5:880 # Hertz
end

MyApp::MathFloat::Pi + MyApp::MathFloat::Phi

include MyApp::MathFloat::NamedValues
Pi + Phi

Pi                #=> Pi
Phi               #=> Phi

Pi / 2            #=> 1.5707963267948966
Phi / 2           #=> 0.809016994374945
Pi + Phi          #=> 4.759626642339683

3 / Pi            #=> 0.954929658551372
2 / Phi           #=> 1.2360679774997934

Phi.value_inspect #=> "1.61803398874989"
Phi.value_to_s    #=> "1.61803398874989"

MyApp::Note::NamedValues::Collection  #=> [A4]

MyApp::Note::A4.play_midi

NamedValueClass Foobar:Array
Foobar B1:[1,2]

Foobar B2:[],    some_param:'dude2', foo:5, bar:89
Foobar B3:[2,1], foo:99
Foobar B4:[2,1], bar:9.3

Foobar::B2.some_param                    #=> 'dude2'
Foobar::B2.some_param = 'kind of cool'
Foobar::B2.some_param                    #=> 'kind of cool'
