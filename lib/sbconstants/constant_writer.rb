require 'delegate'
require 'erb'

module SBConstants
  class ConstantWriter < SimpleDelegator
    def present_constants(section)
      section.constants.map { |constant| [ sanitise_key(constant), constant ] }
    end
  end
end
