require 'set'

module SBConstants
  class Location < StoreItem
    attr_reader :constants
    
    def initialize name
      super
      @constants = Set.new
    end
    
    def << constant
      constants << constant
      constant.locations << self
    end
    
    def eql? other
      other.name == name
    end
    
    def hash
      name.hash
    end
  end
end