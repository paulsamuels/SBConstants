module SBConstants
  Query = Struct.new(:node, :attribute) do
    def xpath
      "//#{node}[@#{attribute}]"
    end
    
    def location
      "#{node}.#{attribute}"
    end
  end
end