require 'delegate'
require 'erb'

module SBConstants
  class ObjcConstantWriter < SimpleDelegator
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
      middlespace = options.space_after_star ? " " : "" 
      template_with_file "\n", %Q{extern NSString *#{middlespace}const <%= sanitise_key(constant) %>;\n}
    end

    def implementation
      middlespace = options.space_after_star ? " " : "" 
      head = %Q{#import "<%= File.basename(options.output_path) %>.h"\n\n}
      body = %Q{NSString *#{middlespace}const <%= sanitise_key(constant) %> = @"<%= constant %>";\n}
      template_with_file head, body
    end

    def template_with_file head, body
      @head = head
      @body = body
      pre_processed_template = ERB.new(File.open("#{templates_dir}objc_body.erb").read, nil, '<>').result(binding)
      ERB.new(pre_processed_template, nil, '<>').result(binding)
    end
  end
end
