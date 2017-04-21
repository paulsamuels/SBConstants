require 'delegate'
require 'erb'

module SBConstants
  class SwiftConstantWriter < SimpleDelegator
    attr_reader :templates_dir

    def initialize data_source, swift_out, templates_dir
      super data_source
      @swift_out = swift_out
      @templates_dir = templates_dir
    end

    def write
      @swift_out.puts template_with_file
    end

    def default_templates_dir
      @default_templates_dir ||= File.dirname(__FILE__) + '/templates'
    end

    def template_with_file
      pre_processed_template = ERB.new(File.open(template_file_path("swift_body.erb")).read, nil, '-').result(binding)
      ERB.new(pre_processed_template, nil, '-').result(binding)
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
