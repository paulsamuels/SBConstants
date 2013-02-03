require 'set'

module SBConstants
  class Location < StoreItem
    attr_accessor :key_path, :constants, :context, :file, :line
    
    def initialize
      @constants = Set.new
    end
    
    def << constant
      constants << constant
      constant.locations << self
    end
    
    def eql? other
      other.class == self.class && other.key_path == key_path
    end
    
    def hash
      key_path.hash
    end
  end
end