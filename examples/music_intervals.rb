$:.unshift File.join( File.dirname( __FILE__ ), '../lib')

require "named_value_class"

# Use lowercase names.  Before you complain, please consider the standard
# abbreviations for the Diatonic Interval names in music theory.  'm' and 'M'
# have distinct meanings:

module Music
  NamedValueClass Interval:Fixnum

  Interval P1: 0   # value is number of semitones
  Interval m2: 1
  Interval M2: 2
  Interval m3: 3
  Interval M3: 4
  Interval P4: 5
  Interval A4: 6
  Interval d5: 6
  Interval P5: 7
  Interval m6: 8
  Interval M6: 9
  Interval m7:10
  Interval M7:11
  Interval P8:12
  
  class Chromatic < Interval; end
  Chromatic d3:2
end

class Scale
  include Music::Interval::NamedValues

  MinorScale = [P1,M2,m3,P4,P5,m6,m7]
  DorianMode = [P1,M2,m3,P4,P5,M6,m7]
end

Music::Interval[3] #=> m3

module Music
  class Chromatic < Interval; end
  
  Chromatic d3:2
end
