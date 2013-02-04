module SBConstants
  Query = Struct.new(:node, :attribute) do
    def regex
      @regex ||= %r!<#{node}\s.*#{attribute}=\"(.*?)\"!
    end
  end
end