require 'delegate'
require 'erb'

module SBConstants
  class SwiftConstantWriter < SimpleDelegator
    def initialize data_source, swift_out
      super data_source
      @swift_out = swift_out
    end

    def write
      head = %Q{\nimport Foundation"\n}
      body = %Q{    case <%= constant.gsub(" ", "") %> = "<%= constant %>"\n}
      @swift_out.puts template_with_file head, body
    end

    def templates_dir
      @templates_dir ||= File.dirname(__FILE__) + '/templates/'
    end

    def template_with_file head, body
      @head = head
      @body = body
      pre_processed_template = ERB.new(File.open("#{templates_dir}swift_body.erb").read, nil, '<>').result(binding)
      ERB.new(pre_processed_template, nil, '<>').result(binding)
    end
  end
end
