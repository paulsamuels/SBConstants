require 'rexml/document'
require 'erb'

module SBConstants
  class CLI
    attr_accessor :options, :constants
    
    def self.run options
      new(options).run
    end
      
    def initialize options
      self.options   = options
      self.constants = []
    end
      
    def run
      Dir['**/*.storyboard'].each do |storyboard|
        doc = REXML::Document.new File.open(storyboard)
        queries.each do |query|
          REXML::XPath.each(doc, query.xpath) do |node|            
            value = node.attribute(query.attribute).value
            
            next unless value.start_with?(options.prefix) if options.prefix
            
            constant = constants.select { |constant| constant.name == value }.first
            
            if constant.nil?
              constant = Constant.new(value) 
              constants << constant
            end
            constant << Location.new(query.location)
          end
        end
        
        sections = []
        
        constants.group_by { |constant| constant.locations }.each do |locations, value|
          sections << ConstantSection.new(locations.to_a, value.map(&:name))
        end
        
        templates_dir = File.dirname(__FILE__) + '/templates/'
        
        header         = ERB.new(File.open(templates_dir + 'header.erb').read, nil, '<>').result binding
        implementation = ERB.new(File.open(templates_dir + 'implementation.erb').read, nil, '<>').result binding
                
        if options.dry_run
          puts header
          puts implementation
        else
          File.open("#{options.output_path}.h", 'w') { |f| f.puts header }
          File.open("#{options.output_path}.m", 'w') { |f| f.puts implementation }  
        end
      end
    end
    
    def queries
      [
        Query.new('segue', 'identifier'),
        Query.new('navigationController', 'storyboardIdentifier'),
        Query.new('viewController', 'storyboardIdentifier'),
        Query.new('tableViewController', 'storyboardIdentifier'),
        Query.new('tableViewCell', 'reuseIdentifier'),
        Query.new('collectionViewController', 'storyboardIdentifier')
      ]
    end
  end
end