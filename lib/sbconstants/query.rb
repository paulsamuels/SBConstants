module SBConstants
  Query = Struct.new(:node, :attribute) do    
    def key_path
      "#{node}.#{attribute}"
    end
    
    def regex
      %r!<#{node}\s.*#{attribute}=\"(.*?)\"!
    end
  end
end