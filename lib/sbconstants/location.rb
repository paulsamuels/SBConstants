module SBConstants
  Location = Struct.new(:node, :attribute, :context, :file, :line) do
    def key_path
      "#{node}.#{attribute}"
    end
    
    def debug
      "#{file}[line:#{line}](#{key_path})"
    end
    
    def eql? other
      self.class == other.class && key_path == other.key_path
    end
    
    def hash
      key_path.hash
    end
  end
end