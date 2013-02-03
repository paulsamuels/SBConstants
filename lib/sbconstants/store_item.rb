module SBConstants
  class StoreItem    
    class << self
      attr_accessor :store
    
      def find_or_create attrs
        store.find_or_create self, attrs
      end
            
      def all
        store.all self
      end
      
      def create attrs={}
        instance = self.new
        attrs.each do |key, value|
          instance.send("#{key}=", value)
        end
        instance
      end
    end
  end
end