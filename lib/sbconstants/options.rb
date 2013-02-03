require 'optparse'
require 'yaml'

module SBConstants
  class Options
    attr_accessor :dry_run, :prefix, :destination, :query_config, :output_path, :source_dir
    
    def self.parse argv
      options = self.new
      OptionParser.new do |opts|
        opts.banner = "Usage: DESTINATION_FILE [options]"
  
        opts.on('--dry-run') do |dry_run|
          options.dry_run = dry_run
        end
  
        opts.on('-p', '--prefix PREFIX') do |prefix|
          options.prefix = prefix
        end
        
        opts.on('-s', '--source-dir SOURCE') do |source_dir|
          options.source_dir = source_dir
        end
      end.parse!(argv)
      
      if argv.first.nil?
        options.dry_run = true
        options.output_path = 'no file given'
      else
        options.output_path = argv.first.chomp(File.extname(ARGV.first)) 
      end
      options
    end
    
    def initialize query_file=nil
      @query_file = query_file || File.expand_path('../../sbconstants/identifiers.yml', __FILE__)
      @source_dir = Dir.pwd
    end
    
    def queries
      load_queries if @queries.nil?
      @queries
    end
    
    private
    
    def load_queries
      @queries = []
      config = YAML.load(File.open(@query_file).read)
      config.each do |nodes, identifiers|
        Array(nodes).each do |node|
          Array(identifiers).each do |identifier|
            @queries << Query.new(node, identifier)
          end
        end
      end      
    end
  end
end