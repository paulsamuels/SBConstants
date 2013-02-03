module SBConstants
  ConstantGroup = Struct.new(:header, :constants)
  class Store
    attr_accessor :objects
    def initialize
      @objects = []
    end
  end
end

require 'sbconstants/cli'
require 'sbconstants/store'
require 'sbconstants/store_item'
require 'sbconstants/constant'
require 'sbconstants/constant_writer'
require 'sbconstants/location'
require 'sbconstants/query'
require 'sbconstants/options'
require "sbconstants/version"
