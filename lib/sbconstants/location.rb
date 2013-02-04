module SBConstants
  Location = Struct.new(:node, :attribute, :context, :file, :line) do
    def key_path
      "#{node}.#{attribute}"
    end
    
    def debug
      "#{file}[line:#{line}](#{key_path})"
    end
  end
end