module SBConstants
  class CLI
    attr_accessor :options, :store, :sections
    
    def self.run argv
      new(Options.parse(argv)).run
    end
      
    def initialize options
      self.options  = options
      self.sections = []
      setup_store
    end
    
    def run
      parse_storyboards
      generate_constant_groups
      write
    end
    
    private
    
    def setup_store
      self.store     = Store.new 
      Location.store = store
      Constant.store = store
    end
    
    def parse_storyboards
      Dir["#{options.source_dir}/**/*.storyboard"].each do |storyboard|
        File.readlines(storyboard).each_with_index do |line, index|
          options.queries.each do |query|
            next unless value = line[query.regex, 1]
            next unless value.start_with?(options.prefix) if options.prefix
            constant = Constant.find_or_create('name' => value)
            location_attrs = { 
              'key_path' => query.location,
              'context'  => line.strip,
              'file'     => File.basename(storyboard),
              'line'     => index + 1
            }
            constant << Location.find_or_create(location_attrs)
          end
        end
      end
    end
    
    def generate_constant_groups
      Constant.all.group_by { |constant| constant.locations }.each do |locations, values|
        sections << ConstantGroup.new(locations, values)
      end
    end
    
    def write
      int_out, imp_out = $stdout, $stdout
                      
      if !options.dry_run
        int_out = File.open("#{options.output_path}.h", 'w')
        imp_out = File.open("#{options.output_path}.m", 'w')
      end
      
      ConstantWriter.new(self, int_out, imp_out).write
      
      if !options.dry_run
        int_out.close
        imp_out.close
      end
    end
  end
end