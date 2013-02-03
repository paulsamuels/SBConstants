require 'delegate'
require 'erb'

module SBConstants
  class ConstantWriter < SimpleDelegator
    def initialize data_source, int_out, imp_out
      super data_source
      @int_out = int_out
      @imp_out = imp_out
    end
    
    def write
      @int_out.puts header
      @imp_out.puts implementation
    end
    
    def templates_dir
      @templates_dir ||= File.dirname(__FILE__) + '/templates/'
    end
    
    def header
      template_with_file 'header'
    end
    
    def implementation
      template_with_file 'implementation'
    end
    
    def template_with_file file
      ERB.new(File.open("#{templates_dir}#{file}.erb").read, nil, '<>').result(binding)
    end
  end
end