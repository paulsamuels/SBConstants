require 'set'

module SBConstants
  class CLI
    attr_accessor :options, :constants, :sections, :storyboards

    def self.run argv
      new(Options.parse(argv)).run
    end

    def initialize options
      self.options     = options
      self.constants   = Hash.new { |h,k| h[k] = Set.new }
      self.storyboards = Array.new
    end

    def run
      parse_storyboards
      refute_key_collisions
      write
    end
    
    def sections
      @sections ||= begin
        [].tap { |sections|
          sections_grouped_by_keypath.each do |locations, constants|
            sections << Section.new(locations.to_a, constants.to_a.sort)
          end
        }.sort_by { |section| section.locations.map(&:key_path).join(',') } 
      end
    end
    
    def sections_grouped_by_keypath
      Hash.new { |h,k| h[k] = Set.new }.tap { |sections_grouped_by_keypath|
        constants.each do |constant, locations|
          sections_grouped_by_keypath[locations] << constant
        end
      }
    end
    
    def sanitise_key key
      key.gsub(" ", "").gsub("-", "")
    end

    private
    
    def refute_key_collisions
      keys_requiring_sanitisation, keys = constants.keys.partition { |constant| constant.include?(' ') }
      
      keys_requiring_sanitisation.each do |key|
        next unless keys.include?(sanitise_key(key))
        
        $stderr.puts <<-EOD
Error: Key collision

The constant "#{key}" will have whitespace and hyphens stripped resulting in a constant named "#{sanitise_key(key)}". 
This creates a problem as the constant "#{sanitise_key(key)}" will want to map to the storyboard constants "#{key}" and "#{sanitise_key(key)}".

To resolve the issue remove the ambiguity in naming - search your storyboards for the key "#{key}"
        EOD
        exit 1 
      end
    end
    
    # Parse all found storyboards and build a dictionary of constant => locations
    #
    # A constant key can potentially exist in many files so locations is a collection
    def parse_storyboards
      Dir["#{options.source_dir}/**/*.storyboard"].each_with_index do |storyboard, storyboard_index|

        filename = File.basename(storyboard, '.storyboard')
        storyboards << filename

        constants[filename] << Location.new('storyboardNames', nil, storyboard, filename, storyboard_index + 1)


        File.readlines(storyboard).each_with_index do |line, index|
          options.queries.each do |query|
            next unless value = line[query.regex, 1]
            next if value.strip.empty?
            next unless value.start_with?(options.prefix) if options.prefix

            constants[value] << Location.new(query.node, query.attribute, line.strip, filename, index + 1)
          end
        end
      end
    end

    def write
      int_out, imp_out, swift_out = $stdout, $stdout, $stdout
      dry_run = options.dry_run

      if options.use_swift
          swift_out = File.open("#{options.output_path}.swift", 'w') unless dry_run
          SwiftConstantWriter.new(self, swift_out).write
          swift_out.close
      else

        int_out = File.open("#{options.output_path}.h", 'w') unless dry_run
        imp_out = File.open("#{options.output_path}.m", 'w') unless dry_run

        ObjcConstantWriter.new(self, int_out, imp_out, options.templates_dir).write

        int_out.close unless dry_run
        imp_out.close unless dry_run
      end
    end
  end
end
