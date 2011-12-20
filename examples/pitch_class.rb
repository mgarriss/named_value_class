require 'named_value_class'

NamedValueClass Pitch:Fixnum, constrain:0..11 do
  minus_a :Interval do |lhs,minus,rhs|
    result = minus.call(rhs) % 12
    is_sharp? ? Pitch.sharps[result] : Pitch.flats[result]
  end
  
  all_operators_with_a :Pitch, raise:SyntaxError
  
  def as_flat
    self.class.naturals[self] || self.class.flats[self]
  end
  
  def as_sharp
    self.class.naturals[self] || self.class.sharps[self]
  end
end

Pitch Bs:  0,   sharp:true  
Pitch C:   0, natural:true 
Pitch Cs:  1,   sharp:true 
Pitch Db:  1,    flat:true 
Pitch D:   2, natural:true 
Pitch Ds:  3,   sharp:true 
Pitch Eb:  3,    flat:true 
Pitch E:   4, natural:true 
Pitch Fb:  4,    flat:true 
Pitch Es:  5,   sharp:true 
Pitch F:   5, natural:true 
Pitch Fs:  6,   sharp:true 
Pitch Gb:  6,    flat:true 
Pitch G:   7, natural:true 
Pitch Gs:  8,   sharp:true 
Pitch Ab:  8,    flat:true 
Pitch A:   9, natural:true 
Pitch As: 10,   sharp:true 
Pitch Bb: 10,    flat:true 
Pitch B:  11, natural:true 
Pitch Cb: 11,    flat:true 
