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
      template_with_file "\n", %Q{extern NSString * const <%= constant %>;\n}
    end
    
    def implementation
      head = %Q{\n#import "<%= File.basename(options.output_path) %>.h"\n\n}
      body = %Q{NSString * const <%= constant %> = @"<%= constant %>";\n}
      template_with_file head, body
    end
    
    def template_with_file head, body
      pre_processed_template = ERB.new(File.open("#{templates_dir}body.erb").read, nil, '<>').result(binding)
      ERB.new(pre_processed_template, nil, '<>').result(binding)
    end
  end
end