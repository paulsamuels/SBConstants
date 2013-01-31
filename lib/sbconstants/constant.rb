require 'set'

module SBConstants
  class Constant
    attr_reader :name, :locations
    
    def initialize name
      @name = name
      @locations = Set.new
    end
    
    def << location
      locations << location
      location.constants << self if !location.constants.include? self
    end
    
    def eql? other
      other.name == name
    end
    
    def hash
      name.hash
    end
  end
end