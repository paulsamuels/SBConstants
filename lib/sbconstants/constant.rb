require 'set'

module SBConstants
  class Constant < StoreItem
    attr_accessor :name, :locations
    
    def initialize
      @locations = Set.new
    end
    
    def << location
      locations << location
      location.constants << self
    end
    
    def eql? other
      other.name == name
    end
    
    def hash
      name.hash
    end
  end
end