module SBConstants
  Section = Struct.new(:locations, :constants) do

    def pretty_title
      title = locations.map(&:key_path).join('')
                               .gsub(".", "")
                               .gsub(" ", "")
                               .gsub("identifier", "Identifier")
                               .gsub("viewcontroller", "ViewController")
                               .gsub("storyboard", "Storyboard")
                               .gsub("reuse", "Reuse")

      title.slice(0,1).capitalize + title.slice(1..-1)
    end

  end
end
