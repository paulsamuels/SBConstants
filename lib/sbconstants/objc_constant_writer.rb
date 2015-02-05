require 'delegate'
require 'erb'

module SBConstants
  class ObjcConstantWriter < SimpleDelegator
    attr_reader :templates_dir
    
    def initialize data_source, int_out, imp_out, templates_dir
      super(data_source)
      @int_out       = int_out
      @imp_out       = imp_out
      @templates_dir = templates_dir
    end

    def write
      @int_out.puts header
      @imp_out.puts implementation
    end

    def default_templates_dir
      @default_templates_dir ||= File.dirname(__FILE__) + '/templates'
    end

    def header
      template_with_file "#import <Foundation/Foundation.h>\n\n", File.open(template_file_path("objc_header.erb")).read
    end

    def implementation
      head = %Q{#import "<%= File.basename(options.output_path) %>.h"\n\n}
      template_with_file head, File.open(template_file_path("objc_implementation.erb")).read
    end

    def template_with_file head, body
      @head = head
      @body = body
      pre_processed_template = ERB.new(File.open(template_file_path("objc_body.erb")).read, nil, '<>').result(binding)
      ERB.new(pre_processed_template, nil, '<>').result(binding)
    end
    
    def present_constants(section)
      section.constants.map { |constant| [ sanitise_key(constant), constant ] }
    end
    
    def template_file_path basename
      if templates_dir && File.exist?("#{templates_dir}/#{basename}")
        "#{templates_dir}/#{basename}"
      else
        "#{default_templates_dir}/#{basename}"
      end
    end
  end
end
