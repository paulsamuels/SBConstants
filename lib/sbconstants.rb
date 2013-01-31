module SBConstants
  ConstantSection = Struct.new(:header, :constants)
end

require 'sbconstants/cli'
require 'sbconstants/constant'
require 'sbconstants/location'
require 'sbconstants/query'
require "sbconstants/version"
