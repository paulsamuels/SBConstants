require 'optparse'
require 'yaml'

module SBConstants
  class Options
    attr_accessor :dry_run, :prefix, :destination, :query_config, :output_path, :source_dir, :verbose, :query_file, :use_swift, :space_after_star

    def self.parse argv
      options = self.new
      OptionParser.new do |opts|
        opts.banner = "Usage: DESTINATION_FILE [options]"

        opts.on('-p', '--prefix=<prefix>', 'Only match identifiers with <prefix>') do |prefix|
          options.prefix = prefix
        end

        opts.on('-s', '--source-dir=<source>', 'Directory containing storyboards') do |source_dir|
          options.source_dir = source_dir
        end

        opts.on('-w', '--swift', 'Output to a Swift File') do |use_swift|
          options.use_swift = use_swift
        end

        opts.on('-q', '--queries=<queries>', 'YAML file containing queries') do |queries|
          options.query_file = queries
        end

        opts.on('-d', '--dry-run', 'Output to STDOUT') do |dry_run|
          options.dry_run = dry_run
        end

        opts.on('-v', '--verbose', 'Verbose output') do |verbose|
          options.verbose = verbose
        end

        opts.on('-r', '--remove-space', 'Remove space before * on const declaration "NSString const*" vs "NSString const *"') do |verbose|
          options.space_after_star = false
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

    def initialize
      self.query_file = File.expand_path('../../sbconstants/identifiers.yml', __FILE__)
      self.source_dir = Dir.pwd
      self.space_after_star = true
    end

    def queries
      load_queries if @queries.nil?
      @queries
    end

    private

    def load_queries
      @queries = []
      config = YAML.load(File.open(query_file).read)
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
