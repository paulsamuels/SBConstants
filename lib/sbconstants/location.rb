require 'set'

module SBConstants
  class Location
    attr_reader :path, :constants
    
    def initialize path
      @path = path
      @constants = Set.new
    end
    
    def << constant
      constants << constant
      constant.locations << self if !constant.locations.include? self
    end
    
    def eql? other
      other.path == path
    end
    
    def hash
      path.hash
    end
  end
end